/-!
# Lesson 0: Rust verification from scratch

Before using Aeneas, we do by hand, on a tiny scale, what it does for us.
This file imports nothing (not even Aeneas), so you can check it right away:

```
lean Remittance/FromScratch.lean
```

The four ideas below are the whole trick behind Aeneas. Lessons 1 to 4
(`Remittance/Proofs/*.lean`) apply the same ideas, at full scale, to code that
Aeneas generated from `rust/src/lib.rs`.

1. **Panics become values.** A Rust function `fn f(..) -> T` becomes a Lean
   function `f : .. → Result T`, where `Result` is either `ok v` or `fail e`.
   Integer overflow, out-of-bounds indexing and `panic!()` all become `fail`.
2. **Specifications are "succeeds, and the result satisfies P".** We write
   `f x ⦃ y => P y ⦄`. Proving it shows that `f x` *does not panic* and that
   its result satisfies `P`.
3. **Mutable borrows become backward functions.** Borrowing `&mut v[i]`
   returns the current value plus a function that rebuilds `v` once you give
   the new value back. Rust's ownership rules are what make this sound:
   while you hold the `&mut`, nobody else can observe `v`.
4. **Loops become recursive functions,** and loop invariants become
   preconditions of the recursive function's specification.
-/

namespace FromScratch

/-! ## 1. Panics become values -/

inductive Error where
  | integerOverflow
  | divisionByZero
  | arrayOutOfBounds
  deriving Repr, DecidableEq

inductive Result (α : Type) where
  | ok : α → Result α
  | fail : Error → Result α
  deriving Repr

open Result

/-- `Result` is a monad: in a `do` block, `let x ← e` stops at the first `fail`,
exactly like a panic unwinds out of a Rust function. -/
instance : Monad Result where
  pure := ok
  bind x f := match x with
    | ok a => f a
    | fail e => fail e

@[simp] theorem bind_ok {α β : Type} (a : α) (f : α → Result β) :
    (ok a >>= f) = f a := rfl

@[simp] theorem pure_eq_ok {α : Type} (a : α) : (pure a : Result α) = ok a := rfl

/-! ## 2. Specifications -/

/-- `r.spec P`: the computation succeeds and its result satisfies `P`. -/
def Result.spec {α : Type} (r : Result α) (P : α → Prop) : Prop :=
  match r with
  | ok a => P a
  | fail _ => False

/-- The same notation as Aeneas: `f x ⦃ y => P y ⦄`. -/
syntax:50 term:51 " ⦃ " ident " => " term " ⦄" : term
macro_rules
  | `($r ⦃ $x:ident => $p ⦄) => `(Result.spec $r (fun $x => $p))

@[simp] theorem spec_ok {α : Type} (a : α) (P : α → Prop) :
    (ok a).spec P ↔ P a := Iff.rfl

@[simp] theorem spec_fail {α : Type} (e : Error) (P : α → Prop) :
    ¬ (fail e : Result α).spec P := fun h => h

/-- **The rule behind Aeneas' `step` tactic.** To prove a spec about
`let a ← m; k a`, prove a spec `P` about `m`, then prove the spec about `k a`
for every `a` satisfying `P`. -/
theorem spec_bind {α β : Type} {m : Result α} {k : α → Result β}
    {P : α → Prop} {Q : β → Prop}
    (hm : m.spec P) (hk : ∀ a, P a → (k a).spec Q) : (m >>= k).spec Q := by
  cases m with
  | ok a => exact hk a hm
  | fail e => exact hm.elim

/-- Weakening the postcondition. -/
theorem spec_mono {α : Type} {m : Result α} {P Q : α → Prop}
    (hm : m.spec P) (h : ∀ a, P a → Q a) : m.spec Q := by
  cases m with
  | ok a => exact h a hm
  | fail e => exact hm.elim

/-! ## Machine integers

A `u64` is a natural number together with a proof that it fits in 64 bits.
Arithmetic is *checked*, as in a Rust debug build: overflow is a `fail`. -/

def U64.max : Nat := 18446744073709551615 -- 2^64 - 1

structure U64 where
  val : Nat
  hmax : val ≤ U64.max

/-- Literals: `U64.ofNat 10000`. The bound is checked by `decide`. -/
def U64.ofNat (n : Nat) (h : n ≤ U64.max := by decide) : U64 := ⟨n, h⟩

def U64.add (x y : U64) : Result U64 :=
  if h : x.val + y.val ≤ U64.max then ok ⟨x.val + y.val, h⟩
  else fail .integerOverflow

def U64.sub (x y : U64) : Result U64 :=
  if h : y.val ≤ x.val then ok ⟨x.val - y.val, by have := x.hmax; omega⟩
  else fail .integerOverflow

def U64.mul (x y : U64) : Result U64 :=
  if h : x.val * y.val ≤ U64.max then ok ⟨x.val * y.val, h⟩
  else fail .integerOverflow

def U64.div (x y : U64) : Result U64 :=
  if y.val = 0 then fail .divisionByZero
  else ok ⟨x.val / y.val, Nat.le_trans (Nat.div_le_self _ _) x.hmax⟩

/-- So that we can write `x + y`, `x - y`, … like Aeneas does. Note the
return type: `x + y : Result U64`. -/
instance : HAdd U64 U64 (Result U64) := ⟨U64.add⟩
instance : HSub U64 U64 (Result U64) := ⟨U64.sub⟩
instance : HMul U64 U64 (Result U64) := ⟨U64.mul⟩
instance : HDiv U64 U64 (Result U64) := ⟨U64.div⟩

/-! Each operation gets a spec. Its precondition is exactly "this does not
overflow". These play the role of Aeneas' `U64.add_spec` & co. -/

theorem U64.add_spec {x y : U64} (h : x.val + y.val ≤ U64.max) :
    (x + y) ⦃ z => z.val = x.val + y.val ⦄ := by
  show (U64.add x y).spec _
  simp [U64.add, h]

theorem U64.sub_spec {x y : U64} (h : y.val ≤ x.val) :
    (x - y) ⦃ z => z.val = x.val - y.val ⦄ := by
  show (U64.sub x y).spec _
  simp [U64.sub, h]

theorem U64.mul_spec {x y : U64} (h : x.val * y.val ≤ U64.max) :
    (x * y) ⦃ z => z.val = x.val * y.val ⦄ := by
  show (U64.mul x y).spec _
  simp [U64.mul, h]

theorem U64.div_spec {x y : U64} (h : y.val ≠ 0) :
    (x / y) ⦃ z => z.val = x.val / y.val ⦄ := by
  show (U64.div x y).spec _
  simp [U64.div, h]

/-! ## Example 1: the naive fee

```rust
pub fn proportional_fee_naive(amount: u64, rate_bps: u64) -> u64 {
    amount * rate_bps / 10_000
}
```

The translation is mechanical: every operation that may panic becomes a
`let … ← …`. -/

def proportional_fee_naive (amount rate_bps : U64) : Result U64 := do
  let i ← amount * rate_bps
  i / U64.ofNat 10000

/-- Lean *computes* that the function panics on this input. This is the bug the
Rust test `naive_fee_overflows` exhibits. -/
theorem proportional_fee_naive_overflows :
    proportional_fee_naive (U64.ofNat 200000000000000000) (U64.ofNat 100)
      = fail .integerOverflow := by
  rfl

/-- With the right precondition, the function is correct. We prove it by hand
with `spec_bind`, which is exactly what Aeneas' `step` tactic automates. -/
theorem proportional_fee_naive_spec (amount rate_bps : U64)
    (h : amount.val * rate_bps.val ≤ U64.max) :
    proportional_fee_naive amount rate_bps
      ⦃ fee => fee.val = amount.val * rate_bps.val / 10000 ⦄ := by
  unfold proportional_fee_naive
  -- `let i ← amount * rate_bps`
  apply spec_bind (U64.mul_spec h)
  intro i hi
  -- `i / 10000`
  apply spec_mono (U64.div_spec (by decide))
  intro fee hfee
  simp only [hfee, hi, U64.ofNat]

/-! ## Example 2: mutable borrows, and conservation of money

```rust
/// Move `amount` from account `src` to account `dst`.
pub fn pay(balances: &mut Vec<u64>, src: usize, dst: usize, amount: u64) {
    balances[src] -= amount;
    balances[dst] += amount;
}
```

`balances[src] -= amount` borrows `&mut balances[src]`. We model that borrow
with `index_mut`, which returns the element *and a backward function* that
writes a new element back. The `&mut Vec` argument becomes an input, and the
updated vector becomes an output. -/

/-- `&mut v[i]`: the current value, plus how to put a new value back. -/
def index_mut (v : List U64) (i : Nat) : Result (U64 × (U64 → List U64)) :=
  if h : i < v.length then ok (v[i], fun x => v.set i x)
  else fail .arrayOutOfBounds

theorem index_mut_spec (v : List U64) (i : Nat) (h : i < v.length) :
    index_mut v i ⦃ p => p.1 = v[i] ∧ p.2 = fun x => v.set i x ⦄ := by
  simp [index_mut, h]

def pay (balances : List U64) (src dst : Nat) (amount : U64) :
    Result (List U64) := do
  let (x, back) ← index_mut balances src
  let x1 ← x - amount
  let balances1 := back x1
  let (y, back1) ← index_mut balances1 dst
  let y1 ← y + amount
  ok (back1 y1)

/-- The total amount of money in the ledger, as a mathematical number. -/
def supply : List U64 → Nat
  | [] => 0
  | x :: xs => x.val + supply xs

/-- Overwriting one balance changes the supply by the difference. -/
theorem supply_set (l : List U64) (i : Nat) (x : U64) (h : i < l.length) :
    supply (l.set i x) + l[i].val = supply l + x.val := by
  induction l generalizing i with
  | nil => simp at h
  | cons y ys ih =>
    cases i with
    | zero => simp only [List.set_cons_zero, supply, List.getElem_cons_zero]; omega
    | succ i =>
      have := ih i (by simp at h; omega)
      simp only [List.set_cons_succ, supply, List.getElem_cons_succ]
      omega

/-- One balance is at most the total supply. -/
theorem le_supply (l : List U64) (i : Nat) (h : i < l.length) :
    l[i].val ≤ supply l := by
  induction l generalizing i with
  | nil => simp at h
  | cons y ys ih =>
    cases i with
    | zero => simp only [supply, List.getElem_cons_zero]; omega
    | succ i =>
      have := ih i (by simp at h; omega)
      simp only [supply, List.getElem_cons_succ]
      omega

/-- **`pay` never panics and conserves money**, provided that the accounts are
valid and distinct, the sender has enough funds, and the ledger satisfies the
supply invariant (`supply ≤ u64::MAX`).

The last hypothesis is the interesting one. Without it, `balances[dst] +=
amount` could overflow. With it, the receiver's new balance is at most the
(unchanged) total supply, so it fits. -/
theorem pay_spec (l : List U64) (src dst : Nat) (amount : U64)
    (hsrc : src < l.length) (hdst : dst < l.length) (hne : src ≠ dst)
    (hfunds : amount.val ≤ l[src].val)
    (hsupply : supply l ≤ U64.max) :
    pay l src dst amount ⦃ l' => supply l' = supply l ∧ l'.length = l.length ⦄ := by
  unfold pay
  -- `let (x, back) ← index_mut balances src`
  apply spec_bind (index_mut_spec l src hsrc)
  rintro ⟨x, back⟩ ⟨hx, hback⟩
  simp only at hx hback
  subst hx hback
  -- `let x1 ← x - amount`
  apply spec_bind (U64.sub_spec hfunds)
  intro x1 hx1
  -- `let (y, back1) ← index_mut balances1 dst`
  have hdst' : dst < (l.set src x1).length := by simpa using hdst
  apply spec_bind (index_mut_spec (l.set src x1) dst hdst')
  rintro ⟨y, back1⟩ ⟨hy, hback1⟩
  simp only at hy hback1
  subst hy hback1
  -- The receiver's balance did not change when we wrote the sender's.
  have hy : (l.set src x1)[dst] = l[dst] := by simp [hne]
  -- Money accounting: what did writing the sender's balance do to the supply?
  have h1 := supply_set l src x1 hsrc
  have h2 := le_supply (l.set src x1) dst hdst'
  rw [hy] at h2
  -- `let y1 ← y + amount`: here is where the supply invariant is used.
  apply spec_bind (U64.add_spec (by rw [hy]; omega))
  intro y1 hy1
  rw [hy] at hy1
  have h3 := supply_set (l.set src x1) dst y1 hdst'
  rw [hy] at h3
  simp only [spec_ok, List.length_set, and_true]
  omega

/-! ## Example 3: loops

```rust
pub fn total_supply(balances: &Vec<u64>) -> u64 {
    let mut total = 0;
    let mut i = 0;
    while i < balances.len() {
        total += balances[i];
        i += 1;
    }
    total
}
```

A `while` loop becomes a recursive function whose parameters are the
variables the loop modifies (`total`, `i`). (Aeneas uses `partial_fixpoint`
and lets you prove termination in the *spec*; to keep this file small we
prove termination in the *definition*.) -/

def index (v : List U64) (i : Nat) : Result U64 :=
  if h : i < v.length then ok v[i] else fail .arrayOutOfBounds

theorem index_spec (v : List U64) (i : Nat) (h : i < v.length) :
    index v i ⦃ x => x = v[i] ⦄ := by
  simp [index, h]

def total_supply_loop (balances : List U64) (total : U64) (i : Nat) :
    Result U64 :=
  if i < balances.length then do
    let x ← index balances i
    let total1 ← total + x
    total_supply_loop balances total1 (i + 1)
  else ok total
termination_by balances.length - i

def total_supply (balances : List U64) : Result U64 :=
  total_supply_loop balances (U64.ofNat 0) 0

theorem supply_take_succ (l : List U64) (i : Nat) (h : i < l.length) :
    supply (l.take (i + 1)) = supply (l.take i) + l[i].val := by
  induction l generalizing i with
  | nil => simp at h
  | cons y ys ih =>
    cases i with
    | zero => simp [supply]
    | succ i =>
      have := ih i (by simp at h; omega)
      simp only [List.take_succ_cons, supply, List.getElem_cons_succ, this]
      omega

theorem supply_take_le (l : List U64) (i : Nat) : supply (l.take i) ≤ supply l := by
  induction l generalizing i with
  | nil => simp [supply]
  | cons y ys ih =>
    cases i with
    | zero => simp [supply]
    | succ i =>
      have := ih i
      simp only [List.take_succ_cons, supply]
      omega

/-- The loop invariant is the precondition `total = supply (take i)`:
"`total` is the sum of the balances visited so far". The proof follows the
recursion of the loop, and `termination_by` justifies the recursive use of the
theorem itself (an induction on `length - i`). -/
theorem total_supply_loop_spec (l : List U64) (total : U64) (i : Nat)
    (hinv : total.val = supply (l.take i))
    (hsupply : supply l ≤ U64.max) :
    total_supply_loop l total i ⦃ r => r.val = supply l ⦄ := by
  unfold total_supply_loop
  split
  · rename_i hi
    -- `let x ← index balances i`
    apply spec_bind (index_spec l i hi)
    intro x hx
    subst hx
    -- `let total1 ← total + x`: no overflow, since a prefix sum fits.
    have hstep := supply_take_succ l i hi
    have hle := supply_take_le l (i + 1)
    apply spec_bind (U64.add_spec (by omega))
    intro total1 htotal1
    -- The recursive call: the invariant holds for `i + 1`.
    exact total_supply_loop_spec l total1 (i + 1) (by omega) hsupply
  · rename_i hi
    -- Loop exit: `i ≥ length`, so the prefix is the whole list.
    rw [List.take_of_length_le (by omega)] at hinv
    simpa using hinv
termination_by l.length - i

theorem total_supply_spec (l : List U64) (hsupply : supply l ≤ U64.max) :
    total_supply l ⦃ r => r.val = supply l ⦄ :=
  total_supply_loop_spec l (U64.ofNat 0) 0 (by simp [U64.ofNat, supply]) hsupply

/-! ## Putting it together

Specs compose: from the specs of `pay` and `total_supply` we derive a
statement about running the *program* `total_supply` before and after `pay`,
without ever unfolding either function again. -/

theorem pay_preserves_total_supply (l : List U64) (src dst : Nat) (amount : U64)
    (hsrc : src < l.length) (hdst : dst < l.length) (hne : src ≠ dst)
    (hfunds : amount.val ≤ l[src].val)
    (hsupply : supply l ≤ U64.max) :
    (do
      let before ← total_supply l
      let l' ← pay l src dst amount
      let after ← total_supply l'
      ok (before.val, after.val)) ⦃ r => r.1 = r.2 ⦄ := by
  apply spec_bind (total_supply_spec l hsupply)
  intro before hbefore
  apply spec_bind (pay_spec l src dst amount hsrc hdst hne hfunds hsupply)
  rintro l' ⟨hl', -⟩
  apply spec_bind (total_supply_spec l' (by omega))
  intro after hafter
  simp only [spec_ok]
  omega

end FromScratch
