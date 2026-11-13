/-!
# Pure facts about sums of lists

The program proofs (`Remittance/Proofs/*.lean`) reduce every question about
money to arithmetic on the *mathematical* sum of the balances. This file holds
that arithmetic.

It deliberately imports nothing: only Lean's core library is used, so you can
check it without Aeneas or Mathlib:

```
lean Remittance/Math.lean
```

Keeping the "pure math" apart from the "program" proofs is good practice: the
lemmas here are reusable, fast to check, and independent of how Aeneas happens
to translate the code.
-/

namespace remittance.Math

universe u

/-- `sumBy f [x₀, x₁, …, xₙ] = f x₀ + f x₁ + … + f xₙ`.

We use it with `f := fun (x : U64) => x.val` to talk about the total amount of
money held in a list of balances. -/
def sumBy {α : Type u} (f : α → Nat) : List α → Nat
  | [] => 0
  | x :: xs => f x + sumBy f xs

variable {α : Type u} (f : α → Nat)

@[simp] theorem sumBy_nil : sumBy f [] = 0 := rfl

@[simp] theorem sumBy_cons (x : α) (xs : List α) :
    sumBy f (x :: xs) = f x + sumBy f xs := rfl

theorem sumBy_append (l₁ l₂ : List α) :
    sumBy f (l₁ ++ l₂) = sumBy f l₁ + sumBy f l₂ := by
  induction l₁ with
  | nil => simp
  | cons x xs ih => simp [ih, Nat.add_assoc]

/-- A single balance never exceeds the total. -/
theorem le_sumBy (l : List α) (i : Nat) (h : i < l.length) :
    f l[i] ≤ sumBy f l := by
  induction l generalizing i with
  | nil => simp at h
  | cons x xs ih =>
    cases i with
    | zero => simp
    | succ i =>
      have := ih i (by simp at h; omega)
      simp only [List.getElem_cons_succ, sumBy_cons]
      omega

/-- Two *distinct* balances never exceed the total.

This is what rules out overflow when a transfer credits the receiver: the
receiver's balance plus the amount is at most receiver + sender, which is at
most the total supply, which fits in a `u64`. -/
theorem add_le_sumBy (l : List α) (i j : Nat)
    (hi : i < l.length) (hj : j < l.length) (hij : i ≠ j) :
    f l[i] + f l[j] ≤ sumBy f l := by
  induction l generalizing i j with
  | nil => simp at hi
  | cons x xs ih =>
    cases i with
    | zero =>
      cases j with
      | zero => contradiction
      | succ j =>
        have := le_sumBy f xs j (by simp at hj; omega)
        simp only [List.getElem_cons_zero, List.getElem_cons_succ, sumBy_cons]
        omega
    | succ i =>
      cases j with
      | zero =>
        have := le_sumBy f xs i (by simp at hi; omega)
        simp only [List.getElem_cons_zero, List.getElem_cons_succ, sumBy_cons]
        omega
      | succ j =>
        have := ih i j (by simp at hi; omega) (by simp at hj; omega) (by omega)
        simp only [List.getElem_cons_succ, sumBy_cons]
        omega

/-- Overwriting one element changes the sum by the difference.

Stated with additions on both sides so that no (truncated) natural-number
subtraction appears: `new_sum + old_value = old_sum + new_value`. -/
theorem sumBy_set (l : List α) (i : Nat) (x : α) (h : i < l.length) :
    sumBy f (l.set i x) + f l[i] = sumBy f l + f x := by
  induction l generalizing i with
  | nil => simp at h
  | cons y ys ih =>
    cases i with
    | zero =>
      simp only [List.set_cons_zero, sumBy_cons, List.getElem_cons_zero]
      omega
    | succ i =>
      have := ih i (by simp at h; omega)
      simp only [List.set_cons_succ, sumBy_cons, List.getElem_cons_succ]
      omega

/-- The bookkeeping identity behind conservation of money: overwrite three
distinct positions `s`, `r`, `t` (sender, receiver, treasury) with `a`, `b`,
`c`. -/
theorem sumBy_set_set_set (l : List α) (s r t : Nat) (a b c : α)
    (hs : s < l.length) (hr : r < l.length) (ht : t < l.length)
    (hsr : s ≠ r) (hst : s ≠ t) (hrt : r ≠ t) :
    sumBy f (((l.set s a).set r b).set t c) + f l[s] + f l[r] + f l[t]
      = sumBy f l + f a + f b + f c := by
  have h1 := sumBy_set f l s a hs
  have h2 := sumBy_set f (l.set s a) r b (by simpa using hr)
  have h3 := sumBy_set f ((l.set s a).set r b) t c (by simpa using ht)
  have e2 : (l.set s a)[r]'(by simpa using hr) = l[r] := by
    simp [hsr]
  have e3 : ((l.set s a).set r b)[t]'(by simpa using ht) = l[t] := by
    simp [hst, hrt]
  rw [e2] at h2
  rw [e3] at h3
  omega

/-- Prefix sums, used for the loop in `total_supply`: one more iteration adds
one more element. -/
theorem sumBy_take_succ (l : List α) (i : Nat) (h : i < l.length) :
    sumBy f (l.take (i + 1)) = sumBy f (l.take i) + f l[i] := by
  rw [List.take_add_one, sumBy_append, List.getElem?_eq_getElem h]
  simp

/-- A prefix sum is at most the full sum. This is the loop's overflow
argument: every partial total is at most the total supply. -/
theorem sumBy_take_le (l : List α) (i : Nat) :
    sumBy f (l.take i) ≤ sumBy f l := by
  have h := sumBy_append f (l.take i) (l.drop i)
  rw [List.take_append_drop] at h
  omega

/-- When the loop exits, the prefix is the whole list. -/
theorem sumBy_take_of_le (l : List α) (i : Nat) (h : l.length ≤ i) :
    sumBy f (l.take i) = sumBy f l := by
  rw [List.take_of_length_le h]

end remittance.Math
