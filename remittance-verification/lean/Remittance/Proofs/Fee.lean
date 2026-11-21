import Aeneas
import Remittance.Code.Funs

/-!
# Lessons 1 and 2: arithmetic, casts, and `Result<_, _>`

> **Status:** written against the Aeneas API at the commit pinned in
> `lakefile.lean`, but not yet machine-checked. See "Status" in
> `../../../README.md`.

Generated code: `Remittance/Code/Funs.lean` (`proportional_fee_naive`,
`proportional_fee`, `quote`).

Workflow for every function, here and in the next lessons:

1. `unfold f`, so the goal shows the body of `f`;
2. `step` (or `step*` for "step until done"), once per monadic call: it looks up
   the `@[step]` spec of the callee (`U64.mul_spec`, `U64.div_spec`, …, or
   one of *our* specs), tries to discharge its precondition with `scalar_tac`,
   and introduces the result together with its postcondition;
3. close what is left (`scalar_tac`, `simp_all`, `agrind`, …).

In each case, the interesting question is which preconditions `step` cannot
discharge on its own. Those are exactly the places where the Rust code could
panic.
-/

open Aeneas Aeneas.Std Result

namespace remittance

/-! ## Lesson 1a: an overflow is a missing precondition

```rust
pub fn proportional_fee_naive(amount: u64, rate_bps: u64) -> u64 {
    amount * rate_bps / 10_000
}
```

**Exercise.** Delete the hypothesis `h` and run the proof. `step` stops at the
multiplication and asks you to prove `↑amount * ↑rate_bps ≤ U64.max`, which is
false for `amount = 2 * 10^17`, `rate_bps = 100`. (Lesson 0 in
`FromScratch.lean` makes Lean compute that failure; the Rust test
`naive_fee_overflows` makes it panic.) -/

@[step]
theorem proportional_fee_naive_spec (amount rate_bps : U64)
    (h : amount.val * rate_bps.val ≤ U64.max) :
    proportional_fee_naive amount rate_bps
      ⦃ fee => fee.val = amount.val * rate_bps.val / 10000 ⦄ := by
  unfold proportional_fee_naive
  step as ⟨ i, hi ⟩     -- `amount * rate_bps`: precondition discharged from `h`
  step as ⟨ fee, hfee ⟩ -- `i / 10000`: the divisor is not zero
  scalar_tac

/-! ## Lesson 1b: widening to `u128`

```rust
pub fn proportional_fee(amount: u64, rate_bps: u64) -> u64 {
    let wide = (amount as u128) * (rate_bps as u128) / 10_000;
    wide as u64
}
```

The multiplication now happens in 128 bits, so it never overflows. But the
cast `wide as u64` *truncates*, and the result is the true fee only if
`wide ≤ u64::MAX`. That is guaranteed when `rate_bps ≤ 10_000` (at most 100 %),
because then `wide ≤ amount`. Without that hypothesis the theorem is false: see
the Rust test `proportional_fee_truncates_above_100_percent`. -/

@[step]
theorem proportional_fee_spec (amount rate_bps : U64) (h : rate_bps.val ≤ 10000) :
    proportional_fee amount rate_bps
      ⦃ fee => fee.val = amount.val * rate_bps.val / 10000 ∧ fee.val ≤ amount.val ⦄ := by
  -- Pure arithmetic first: the product fits in 128 bits, and the quotient
  -- fits in 64 bits. These are the facts `scalar_tac` needs below.
  have hprod : amount.val * rate_bps.val ≤ amount.val * 10000 :=
    Nat.mul_le_mul_left _ h
  have hfits : amount.val * 10000 ≤ U128.max := by scalar_tac
  have hquot : amount.val * rate_bps.val / 10000 ≤ amount.val := by
    have := Nat.div_le_div_right (c := 10000) hprod
    rwa [Nat.mul_div_cancel _ (by decide)] at this
  unfold proportional_fee
  step*
  -- What remains is the postcondition, about `UScalar.cast .U64 wide`.
  -- `wide < 2^64`, so the cast keeps the value unchanged.
  all_goals simp_all [UScalar.cast_val_eq]
  all_goals scalar_tac

/-! ## Lesson 2: a *total* specification of `quote`

`quote` returns `Result<Quote, RemitError>`. In Lean that is
`core.result.Result Quote RemitError`, *inside* Aeneas' `Result` monad: the
outer `Result` says whether the code panics, the inner one is the ordinary
Rust value.

The spec below has no precondition at all. It says that `quote` **never
panics**, for any input, and it describes every possible outcome. -/

@[step]
theorem quote_spec (policy : FeePolicy) (amount : U64) :
    quote policy amount ⦃ r =>
      match r with
      | .Ok q =>
          policy.rate_bps.val ≤ 10000 ∧
          0 < amount.val ∧
          q.amount = amount ∧
          q.fee.val = policy.flat.val + amount.val * policy.rate_bps.val / 10000 ∧
          q.total.val = q.amount.val + q.fee.val
      | .Err .InvalidPolicy => 10000 < policy.rate_bps.val
      | .Err .ZeroAmount => amount.val = 0
      | .Err .AmountTooLarge =>
          U64.max < amount.val + policy.flat.val + amount.val * policy.rate_bps.val / 10000
      | .Err _ => False ⦄ := by
  unfold quote
  -- `step*` follows every branch of the `if`s. Each `u64::MAX - x` is safe
  -- because `x ≤ u64::MAX`; each `+` is safe because the preceding `if`
  -- checked it.
  step*
  all_goals simp_all
  all_goals scalar_tac

end remittance
