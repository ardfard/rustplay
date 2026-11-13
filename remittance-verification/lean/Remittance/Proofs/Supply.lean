import Aeneas
import Remittance.Code.Funs
import Remittance.Math

/-!
# Lesson 3: loops, invariants and termination

> **Status:** written against the Aeneas API at the commit pinned in
> `lakefile.lean`, but not yet machine-checked. See "Status" in
> `../../../README.md`.

Generated code: `Ledger.total_supply_loop` and `Ledger.total_supply` in
`Remittance/Code/Funs.lean`.

```rust
pub fn total_supply(&self) -> u64 {
    let mut total = 0;
    let mut i = 0;
    while i < self.balances.len() {
        total += self.balances[i];
        i += 1;
    }
    total
}
```

With `-loops-to-rec`, Aeneas turns the loop into a recursive function
`total_supply_loop self total i` whose parameters are the loop's live
variables. The function is defined with `partial_fixpoint`, so Lean accepts it
without a termination proof. The termination proof moves to the spec instead
(`termination_by` below), and the spec doubles as a proof that the loop
terminates.

The loop invariant is a precondition of the loop's spec:
`total = supply (balances.take i)`, "`total` is the sum of the balances
visited so far".
-/

open Aeneas Aeneas.Std Result
open remittance.Math

namespace remittance

/-- The total amount of money in a list of balances, as a natural number
(no overflow possible: this is mathematics, not Rust). -/
def supply (l : List U64) : Nat := sumBy (fun x => x.val) l

/-- The ledger invariant, as documented on `struct Ledger` in the Rust code. -/
def Ledger.Inv (self : Ledger) : Prop :=
  self.treasury.val < self.balances.length ∧
  supply self.balances.val ≤ U64.max

/-! The lemmas of `Remittance/Math.lean`, specialised to `supply`. -/

theorem supply_take_succ (l : List U64) (i : Nat) (h : i < l.length) :
    supply (l.take (i + 1)) = supply (l.take i) + l[i].val :=
  sumBy_take_succ _ l i h

theorem supply_take_le (l : List U64) (i : Nat) :
    supply (l.take i) ≤ supply l :=
  sumBy_take_le _ l i

theorem supply_take_of_le (l : List U64) (i : Nat) (h : l.length ≤ i) :
    supply (l.take i) = supply l :=
  sumBy_take_of_le _ l i h

/-- **The loop.** If the invariant holds when we enter the loop at index `i`,
the loop terminates without overflowing and returns the full supply. -/
@[step]
theorem Ledger.total_supply_loop_spec (self : Ledger) (total : U64) (i : Usize)
    (hi : i.val ≤ self.balances.length)
    (hinv : total.val = supply (self.balances.val.take i.val))
    (hsupply : supply self.balances.val ≤ U64.max) :
    Ledger.total_supply_loop self total i
      ⦃ r => r.val = supply self.balances.val ⦄ := by
  unfold Ledger.total_supply_loop
  simp
  split
  · -- Loop body: `i < self.balances.len()`.
    rename_i hlt
    have hlt' : i.val < self.balances.val.length := by scalar_tac
    have hstep := supply_take_succ self.balances.val i.val hlt'
    have hle := supply_take_le self.balances.val (i.val + 1)
    -- `self.balances[i]`
    step as ⟨ x, hx ⟩
    subst hx
    -- `total += x`. Why no overflow: total + x = supply (take (i+1)) ≤ supply ≤ u64::MAX.
    step as ⟨ total1, htotal1 ⟩
    -- `i += 1`. Why no overflow: i < len ≤ usize::MAX.
    step as ⟨ i1, hi1 ⟩
    -- The invariant is re-established for the next iteration.
    have hi1' : i1.val = i.val + 1 := by scalar_tac
    have hinv1 : total1.val = supply (self.balances.val.take i1.val) := by
      rw [hi1', hstep]
      scalar_tac
    -- The recursive call is the next loop iteration: use the theorem itself
    -- (an induction, justified by `termination_by` below).
    exact Ledger.total_supply_loop_spec self total1 i1 (by scalar_tac) hinv1 hsupply
  · -- Loop exit: `i ≥ len`, so the prefix is the whole list.
    rename_i hge
    simp only [WP.spec_ok]
    rw [hinv, supply_take_of_le _ _ (by scalar_tac)]
termination_by self.balances.length - i.val
decreasing_by scalar_decr_tac

/-- `total_supply` computes the supply, provided the supply fits in a `u64`
(part 2 of the ledger invariant). -/
@[step]
theorem Ledger.total_supply_spec (self : Ledger)
    (hsupply : supply self.balances.val ≤ U64.max) :
    Ledger.total_supply self ⦃ r => r.val = supply self.balances.val ⦄ := by
  unfold Ledger.total_supply
  exact Ledger.total_supply_loop_spec self 0#u64 0#usize (by simp)
    (by simp [supply]) hsupply

end remittance
