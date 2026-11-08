import Aeneas
import Remittance.Code.Funs
import Remittance.Math
import Remittance.Proofs.Fee
import Remittance.Proofs.Supply

/-!
# Lesson 4: mutable state, frame conditions, and conservation of money

> **Status:** written against the Aeneas API at the commit pinned in
> `lakefile.lean`, but not yet machine-checked. See "Status" in
> `../../../README.md`.

Generated code: `Ledger.transfer` and `Ledger.deposit` in
`Remittance/Code/Funs.lean`.

A method taking `&mut self` becomes a function that takes `self` and returns
the new `self` next to the Rust return value:

```
Ledger.transfer : Ledger → FeePolicy → Usize → Usize → U64
                → Result (core.result.Result Quote RemitError × Ledger)
```

so a spec has the shape `self.transfer … ⦃ r self' => P r self' ⦄`, where `r`
is the Rust return value and `self'` is the ledger after the call.

Each `self.balances[i] += x` is an `index_mut`, which returns the element and
a *backward function* `index_mut_back`. Applying it to the new element
rebuilds the vector. Its spec says the backward function is `Vec.set`, so
after three updates the new balances are
`((balances.set sender _).set receiver _).set treasury _`. The rest of the
proof is arithmetic about `supply` of such a list, which is in
`Remittance/Math.lean`.
-/

open Aeneas Aeneas.Std Result
open remittance.Math

namespace remittance

/-- **The main theorem.** On a ledger satisfying the invariant, `transfer`

* never panics: no overflow, no out-of-bounds access, whatever the inputs;
* preserves the invariant, and the treasury account;
* **conserves money:** the total supply is unchanged;
* on success, takes exactly `amount + fee` from the sender, gives `amount` to
  the receiver and `fee` to the treasury, and touches no other account;
* on failure, leaves the ledger *exactly* as it was. -/
@[step]
theorem Ledger.transfer_spec (self : Ledger) (policy : FeePolicy)
    (sender receiver : Usize) (amount : U64) (hinv : self.Inv) :
    self.transfer policy sender receiver amount ⦃ r self' =>
      self'.Inv ∧
      self'.treasury = self.treasury ∧
      supply self'.balances.val = supply self.balances.val ∧
      match r with
      | .Ok q =>
          q.amount = amount ∧
          q.total.val = q.amount.val + q.fee.val ∧
          self'.balances.length = self.balances.length ∧
          self'.balances[sender.val]!.val + q.total.val = self.balances[sender.val]!.val ∧
          self'.balances[receiver.val]!.val = self.balances[receiver.val]!.val + q.amount.val ∧
          self'.balances[self.treasury.val]!.val =
            self.balances[self.treasury.val]!.val + q.fee.val ∧
          (∀ j, j ≠ sender.val → j ≠ receiver.val → j ≠ self.treasury.val →
            self'.balances[j]! = self.balances[j]!)
      | .Err _ => self' = self ⦄ := by
  obtain ⟨htre, hsup⟩ := hinv
  unfold Ledger.transfer
  simp only [alloc.vec.Vec.index_slice_index, alloc.vec.Vec.index_mut_slice_index]
  /- The five validation checks. Every failing check returns `Err` together
     with the *original* `self`, so these goals are immediate. -/
  split
  · simp_all [Ledger.Inv, supply]
  split
  · simp_all [Ledger.Inv, supply]
  split
  · simp_all [Ledger.Inv, supply]
  split
  · simp_all [Ledger.Inv, supply]
  split
  · simp_all [Ledger.Inv, supply]
  rename_i hs hr hsr hst hrt
  -- From now on: three valid, pairwise distinct accounts.
  have hs' : sender.val < self.balances.val.length := by scalar_tac
  have hr' : receiver.val < self.balances.val.length := by scalar_tac
  have hsr' : sender.val ≠ receiver.val := by scalar_tac
  have hst' : sender.val ≠ self.treasury.val := by scalar_tac
  have hrt' : receiver.val ≠ self.treasury.val := by scalar_tac
  -- `quote(policy, amount)`: its spec (Lesson 2) has no precondition.
  step as ⟨ r, hq ⟩
  cases r with
  | Err e =>
    -- The quote was refused: return `Err e`, ledger untouched.
    simp_all [Ledger.Inv, supply]
  | Ok q =>
    simp only at hq ⊢
    obtain ⟨-, -, hamount, -, htotal⟩ := hq
    /- The two facts that rule out overflow when crediting: two distinct
       balances together are at most the supply, which fits in a `u64`. -/
    have hsr_sum := add_le_sumBy (fun x : U64 => x.val) self.balances.val
      sender.val receiver.val hs' hr' hsr'
    have hst_sum := add_le_sumBy (fun x : U64 => x.val) self.balances.val
      sender.val self.treasury.val hs' htre hst'
    have hsup' : sumBy (fun x : U64 => x.val) self.balances.val ≤ U64.max := hsup
    simp only at hsr_sum hst_sum
    -- `if self.balances[sender] < q.total { return Err(InsufficientFunds) }`
    step as ⟨ bal, hbal ⟩
    split
    · simp_all [Ledger.Inv, supply]
    rename_i hfunds
    -- `self.balances[sender] -= q.total`: no underflow thanks to the check.
    step as ⟨ b_s, back_s, hb_s, hback_s ⟩
    step as ⟨ b_s', hb_s' ⟩
    -- `self.balances[receiver] += q.amount`: no overflow, by `hsr_sum`.
    step as ⟨ b_r, back_r, hb_r, hback_r ⟩
    step as ⟨ b_r', hb_r' ⟩
    -- `self.balances[treasury] += q.fee`: no overflow, by `hst_sum`.
    step as ⟨ b_t, back_t, hb_t, hback_t ⟩
    step as ⟨ b_t', hb_t' ⟩
    /- The postcondition. The new balances are
       `((balances.set sender b_s').set receiver b_r').set treasury b_t'`. -/
    have hcons := sumBy_set_set_set (fun x : U64 => x.val) self.balances.val
      sender.val receiver.val self.treasury.val b_s' b_r' b_t'
      hs' hr' htre hsr' hst' hrt'
    simp only at hcons
    simp_all [Ledger.Inv, supply]
    split_conjs
    all_goals first
      | scalar_tac
      | (intro j hj1 hj2 hj3; simp_lists [*])
      | simp_lists [*]; scalar_tac

/-- Deposits create money, but only as much as was deposited, and never so
much that the supply invariant breaks. -/
@[step]
theorem Ledger.deposit_spec (self : Ledger) (account : Usize) (amount : U64)
    (hinv : self.Inv) :
    self.deposit account amount ⦃ r self' =>
      self'.Inv ∧
      self'.treasury = self.treasury ∧
      match r with
      | .Ok () => supply self'.balances.val = supply self.balances.val + amount.val
      | .Err _ => self' = self ⦄ := by
  obtain ⟨htre, hsup⟩ := hinv
  unfold Ledger.deposit
  simp only [alloc.vec.Vec.index_mut_slice_index]
  split
  · simp_all [Ledger.Inv, supply]
  rename_i hacc
  have hacc' : account.val < self.balances.val.length := by scalar_tac
  -- `self.total_supply()`: Lesson 3.
  step as ⟨ s, hs ⟩
  step as ⟨ room, hroom ⟩
  split
  · simp_all [Ledger.Inv, supply]
  rename_i hfits
  have hle := le_sumBy (fun x : U64 => x.val) self.balances.val account.val hacc'
  have hsup' : sumBy (fun x : U64 => x.val) self.balances.val ≤ U64.max := hsup
  have hs' : s.val = sumBy (fun x : U64 => x.val) self.balances.val := hs
  simp only at hle
  step as ⟨ b, back, hb, hback ⟩
  step as ⟨ b', hb' ⟩
  have hset := sumBy_set (fun x : U64 => x.val) self.balances.val account.val b' hacc'
  simp only at hset
  simp_all [Ledger.Inv, supply]
  all_goals scalar_tac

/-! ## Putting it together

As in Lesson 0, specs compose. Run the Rust program
`let before = l.total_supply(); l.transfer(..); let after = l.total_supply();`
and the two numbers agree, whatever the inputs, provided only that the ledger
satisfies its invariant. -/

theorem transfer_preserves_total_supply (l : Ledger) (policy : FeePolicy)
    (sender receiver : Usize) (amount : U64) (hinv : l.Inv) :
    (do
      let before ← l.total_supply
      let (_, l') ← l.transfer policy sender receiver amount
      let after ← l'.total_supply
      ok (before, after)) ⦃ before after => before.val = after.val ⦄ := by
  have hsup := hinv.2
  step as ⟨ before, hbefore ⟩            -- `total_supply` (Lesson 3)
  step as ⟨ r, l', hinv', htre', hsupply, hr ⟩  -- `transfer` (above)
  have hsup' := hinv'.2
  step as ⟨ after, hafter ⟩              -- `total_supply` again
  scalar_tac

end remittance
