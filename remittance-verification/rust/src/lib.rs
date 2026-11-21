//! # A tiny remittance ledger, written to be verified
//!
//! This crate is the running example of the study case in `../README.md`.
//! A remittance company holds customer money in a single ledger (one currency,
//! amounts in minor units such as cents). Customers send money to each other;
//! for every transfer the company charges a fee that is credited to a special
//! *treasury* account.
//!
//! The code is ordinary Rust, but it sticks to the subset that
//! [Aeneas](https://github.com/AeneasVerif/aeneas) can translate to Lean:
//! integers, structs, enums, `Vec` indexing, `&`/`&mut` borrows, `if`,
//! `match` and `while` loops. There are no traits, closures, iterators or
//! `#[derive]`s, because each of those brings extra standard-library models
//! into the Lean translation and makes the proofs noisier.
//!
//! What we prove in Lean (see `../lean/Remittance/`):
//!
//! * `proportional_fee` never panics and computes exactly
//!   `amount * rate_bps / 10_000` (when the rate is at most 100 %).
//! * `proportional_fee_naive` *can* panic: it overflows on large amounts.
//! * `quote` never panics; on success `total = amount + fee` and
//!   `fee = flat + amount * rate_bps / 10_000`.
//! * `Ledger::total_supply` never panics (given the ledger invariant) and
//!   returns the mathematical sum of all balances.
//! * `Ledger::transfer` never panics (given the ledger invariant), leaves the
//!   ledger untouched when it returns an error, moves exactly
//!   `amount + fee` out of the sender, and **conserves the total supply**:
//!   no money is created or destroyed.
//! * `Ledger::deposit` increases the supply by exactly the deposited amount
//!   and preserves the ledger invariant.

/// Why a request was rejected. Every rejection leaves the ledger unchanged.
pub enum RemitError {
    /// The fee policy charges more than 100 % (`rate_bps > 10_000`).
    InvalidPolicy,
    /// Sending zero is not allowed.
    ZeroAmount,
    /// `amount + fee` does not fit in a `u64`.
    AmountTooLarge,
    /// An account index is out of range.
    UnknownAccount,
    /// Sender and receiver are the same account, or one of them is the treasury.
    SameAccount,
    /// The sender's balance does not cover `amount + fee`.
    InsufficientFunds,
    /// A deposit would push the total supply above `u64::MAX`.
    SupplyOverflow,
}

/// How much the company charges for a transfer.
pub struct FeePolicy {
    /// Fixed part of the fee, in minor units.
    pub flat: u64,
    /// Proportional part of the fee, in basis points (1 bps = 0.01 %,
    /// 10_000 bps = 100 %).
    pub rate_bps: u64,
}

/// The price of a transfer, as shown to the customer before they confirm it.
pub struct Quote {
    /// What the receiver gets.
    pub amount: u64,
    /// What the company keeps.
    pub fee: u64,
    /// What the sender pays: always `amount + fee`.
    pub total: u64,
}

/// The ledger: one balance per account.
///
/// **Invariant** (not enforced by the type system, but assumed and preserved
/// by the proofs):
/// 1. `treasury < balances.len()`;
/// 2. the sum of all balances fits in a `u64`.
pub struct Ledger {
    pub balances: Vec<u64>,
    /// The account that collects fees.
    pub treasury: usize,
}

/// Proportional part of the fee: `amount * rate_bps / 10_000`, rounded down.
///
/// The product is computed in `u128`, where it cannot overflow
/// (`(2^64 - 1) * (2^64 - 1) < 2^128`). The final `as u64` cast truncates:
/// it is lossless only when `rate_bps <= 10_000`, which is something the
/// proof makes us notice.
pub fn proportional_fee(amount: u64, rate_bps: u64) -> u64 {
    let wide = (amount as u128) * (rate_bps as u128) / 10_000;
    wide as u64
}

/// The "obvious" implementation, kept as a cautionary example.
///
/// `amount * rate_bps` overflows as soon as `amount > u64::MAX / rate_bps`,
/// for example 2 * 10^17 cents at 1 % (100 bps). In a debug build that is a panic; in a
/// release build it silently wraps around and charges a wrong fee. Aeneas
/// makes the overflow visible: the Lean translation can fail.
pub fn proportional_fee_naive(amount: u64, rate_bps: u64) -> u64 {
    amount * rate_bps / 10_000
}

/// Price a transfer of `amount` under `policy`.
///
/// Every arithmetic operation is guarded, so this function never panics;
/// the guards turn would-be overflows into `Err(AmountTooLarge)`.
pub fn quote(policy: &FeePolicy, amount: u64) -> Result<Quote, RemitError> {
    if policy.rate_bps > 10_000 {
        return Err(RemitError::InvalidPolicy);
    }
    if amount == 0 {
        return Err(RemitError::ZeroAmount);
    }
    let proportional = proportional_fee(amount, policy.rate_bps);
    if policy.flat > u64::MAX - proportional {
        return Err(RemitError::AmountTooLarge);
    }
    let fee = policy.flat + proportional;
    if amount > u64::MAX - fee {
        return Err(RemitError::AmountTooLarge);
    }
    Ok(Quote {
        amount,
        fee,
        total: amount + fee,
    })
}

impl Ledger {
    /// The sum of all balances.
    ///
    /// `total += ...` would overflow if the balances summed to more than
    /// `u64::MAX`; part 2 of the ledger invariant rules that out.
    pub fn total_supply(&self) -> u64 {
        let mut total = 0;
        let mut i = 0;
        while i < self.balances.len() {
            total += self.balances[i];
            i += 1;
        }
        total
    }

    /// Put new money into `account` (for example, cash handed over at a
    /// branch). Refuses deposits that would break the supply invariant.
    pub fn deposit(&mut self, account: usize, amount: u64) -> Result<(), RemitError> {
        if account >= self.balances.len() {
            return Err(RemitError::UnknownAccount);
        }
        let supply = self.total_supply();
        if amount > u64::MAX - supply {
            return Err(RemitError::SupplyOverflow);
        }
        self.balances[account] += amount;
        Ok(())
    }

    /// Send `amount` from `sender` to `receiver`, charging a fee under
    /// `policy`. The sender pays `amount + fee`, the receiver gets `amount`
    /// and the treasury gets `fee`.
    ///
    /// All checks happen *before* the first write, so an error leaves the
    /// ledger untouched.
    ///
    /// Note the two `+=` on the receiver and the treasury: they could
    /// overflow in principle. They cannot overflow on a ledger that satisfies
    /// the invariant, and proving that is part of the study case.
    pub fn transfer(
        &mut self,
        policy: &FeePolicy,
        sender: usize,
        receiver: usize,
        amount: u64,
    ) -> Result<Quote, RemitError> {
        let n = self.balances.len();
        if sender >= n {
            return Err(RemitError::UnknownAccount);
        }
        if receiver >= n {
            return Err(RemitError::UnknownAccount);
        }
        if sender == receiver {
            return Err(RemitError::SameAccount);
        }
        let treasury = self.treasury;
        if sender == treasury {
            return Err(RemitError::SameAccount);
        }
        if receiver == treasury {
            return Err(RemitError::SameAccount);
        }
        // `quote(policy, amount)?` would also work, but `?` goes through the
        // `Try`/`FromResidual` traits; an explicit `match` keeps the Lean
        // translation (and therefore the proofs) simpler.
        #[allow(clippy::question_mark)]
        let q = match quote(policy, amount) {
            Ok(q) => q,
            Err(e) => return Err(e),
        };
        if self.balances[sender] < q.total {
            return Err(RemitError::InsufficientFunds);
        }
        self.balances[sender] -= q.total;
        self.balances[receiver] += q.amount;
        self.balances[treasury] += q.fee;
        Ok(q)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const POLICY: FeePolicy = FeePolicy {
        flat: 100,     // $1.00
        rate_bps: 150, // 1.5 %
    };

    fn ledger() -> Ledger {
        // Account 0 is the treasury; accounts 1..=3 are customers.
        Ledger {
            balances: vec![0, 100_000, 5_000, 0],
            treasury: 0,
        }
    }

    #[test]
    fn proportional_fee_examples() {
        assert_eq!(proportional_fee(10_000, 150), 150);
        assert_eq!(proportional_fee(99, 150), 1); // 1.485 rounded down
        assert_eq!(proportional_fee(u64::MAX, 10_000), u64::MAX);
        assert_eq!(proportional_fee(u64::MAX, 0), 0);
    }

    #[test]
    fn proportional_fee_truncates_above_100_percent() {
        // 2 * (2^64 - 1) does not fit in a u64: the `as u64` cast wraps.
        // This is why the Lean spec needs `rate_bps <= 10_000`.
        assert_eq!(proportional_fee(u64::MAX, 20_000), u64::MAX - 1);
    }

    #[test]
    #[cfg(debug_assertions)]
    #[should_panic(expected = "overflow")]
    fn naive_fee_overflows() {
        // 2 * 10^17 cents at 1 %: the product 2 * 10^19 does not fit in 64 bits,
        // although the fee itself (2 * 10^15) would.
        let amount = std::hint::black_box(200_000_000_000_000_000u64);
        proportional_fee_naive(amount, std::hint::black_box(100));
    }

    #[test]
    fn quote_example() {
        let q = quote(&POLICY, 10_000).ok().unwrap();
        assert_eq!((q.amount, q.fee, q.total), (10_000, 250, 10_250));
    }

    #[test]
    fn quote_errors() {
        let greedy = FeePolicy { flat: 0, rate_bps: 10_001 };
        assert!(matches!(quote(&greedy, 1), Err(RemitError::InvalidPolicy)));
        assert!(matches!(quote(&POLICY, 0), Err(RemitError::ZeroAmount)));
        assert!(matches!(quote(&POLICY, u64::MAX), Err(RemitError::AmountTooLarge)));
        let huge_flat = FeePolicy { flat: u64::MAX, rate_bps: 1 };
        assert!(matches!(quote(&huge_flat, 10_000), Err(RemitError::AmountTooLarge)));
    }

    #[test]
    fn transfer_moves_money_and_conserves_supply() {
        let mut l = ledger();
        let before = l.total_supply();
        let q = l.transfer(&POLICY, 1, 2, 10_000).ok().unwrap();
        assert_eq!(q.total, 10_250);
        assert_eq!(l.balances, vec![250, 89_750, 15_000, 0]);
        assert_eq!(l.total_supply(), before);
    }

    #[test]
    fn transfer_errors_leave_ledger_untouched() {
        let mut l = ledger();
        let snapshot = l.balances.clone();
        assert!(matches!(l.transfer(&POLICY, 1, 9, 10), Err(RemitError::UnknownAccount)));
        assert!(matches!(l.transfer(&POLICY, 1, 1, 10), Err(RemitError::SameAccount)));
        assert!(matches!(l.transfer(&POLICY, 0, 1, 10), Err(RemitError::SameAccount)));
        assert!(matches!(l.transfer(&POLICY, 1, 0, 10), Err(RemitError::SameAccount)));
        assert!(matches!(l.transfer(&POLICY, 1, 2, 0), Err(RemitError::ZeroAmount)));
        assert!(matches!(l.transfer(&POLICY, 2, 3, 5_000), Err(RemitError::InsufficientFunds)));
        assert_eq!(l.balances, snapshot);
    }

    #[test]
    fn deposit_respects_supply_cap() {
        let mut l = ledger();
        assert!(l.deposit(3, 42).is_ok());
        assert_eq!(l.balances[3], 42);
        assert_eq!(l.total_supply(), 105_042);
        assert!(matches!(l.deposit(3, u64::MAX), Err(RemitError::SupplyOverflow)));
        assert!(matches!(l.deposit(7, 1), Err(RemitError::UnknownAccount)));
        assert_eq!(l.total_supply(), 105_042);
    }
}
