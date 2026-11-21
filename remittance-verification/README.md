# Study case: verifying a Rust remittance ledger in Lean

This folder is a hands-on introduction to **verifying Rust programs in Lean 4**
with [Aeneas](https://github.com/AeneasVerif/aeneas). The running example is a
small remittance system: customers send money to each other through a ledger,
and the company charges a fee on every transfer.

By the end you will have proved, about the *actual Rust code*, that:

| Property | Where |
|---|---|
| The fee computation never overflows and computes exactly `amount * rate / 10_000` | Lesson 1 |
| The "obvious" fee computation **does** overflow (a real bug), and Lean finds the input | Lessons 0 and 1 |
| `quote` never panics, for any input, and every error code means what it says | Lesson 2 |
| `total_supply`'s `while` loop terminates, never overflows, and returns the sum of all balances | Lesson 3 |
| `transfer` never panics on a well-formed ledger, **conserves money**, touches only the three accounts involved, and leaves the ledger untouched on error | Lesson 4 |
| `deposit` adds exactly the deposited amount and keeps the ledger well-formed | Lesson 4 |

```
remittance-verification/
├── Makefile                     test / lesson0 / extract / proofs
├── rust/                        the Rust crate (the source of truth)
│   └── src/lib.rs
└── lean/                        the Lean project
    ├── lakefile.lean            depends on the Aeneas Lean library (pinned commit)
    ├── Remittance/FromScratch.lean   Lesson 0: the ideas, with no dependencies
    ├── Remittance/Math.lean          pure lemmas about sums of lists (no dependencies)
    ├── Remittance/Code/Types.lean    Rust types, translated by Aeneas
    ├── Remittance/Code/Funs.lean     Rust functions, translated by Aeneas
    └── Remittance/Proofs/
        ├── Fee.lean             Lessons 1 and 2
        ├── Supply.lean          Lesson 3
        └── Ledger.lean          Lesson 4
```

---

## Status: what has been checked

Be clear about this before you start:

| Part | Status |
|---|---|
| `rust/` | `cargo test`: 8 tests pass, `cargo clippy` is clean. |
| `Remittance/FromScratch.lean` (Lesson 0) | **Machine-checked** with Lean 4.35.0. No `sorry`; only the standard axioms (`propext`, `Quot.sound`). |
| `Remittance/Math.lean` | **Machine-checked** with Lean 4.35.0, same axioms. |
| `Remittance/Code/*.lean` | **Hand-written** to mirror Aeneas' output conventions at the pinned commit (names, `Result` encoding, backward functions, `-loops-to-rec` style). It was *not* produced by running Aeneas. Run `make extract` and `git diff` to replace it with the real output. |
| `Remittance/Proofs/*.lean` (Lessons 1–4) | **Written against the Aeneas API at the pinned commit but not yet machine-checked.** The theorem *statements* are the core of the lessons and should be stable. Expect to adjust some tactic lines (hypothesis names after `step as ⟨…⟩`, which finishing tactic closes which goal) the first time you run `lake build`. |

The environment this study case was written in could not build Charon/Aeneas or
download Mathlib, so the second half has not run end to end yet. Lesson 0 runs as is.

---

## 1. The big picture

Aeneas does not verify Rust directly. It **translates** a Rust crate into a
*pure functional* Lean program with the same behaviour, and you prove theorems
about that program.

```
 rust/src/lib.rs
       │  charon   (a rustc driver: compiles the crate, dumps its MIR)
       ▼
 remittance.llbc   ("Low-Level Borrow Calculus": MIR, cleaned up, as JSON)
       │  aeneas -backend lean
       ▼
 lean/Remittance/Code/{Types,Funs}.lean      ← generated, never edited by hand
       │  you
       ▼
 lean/Remittance/Proofs/*.lean               ← specs and proofs
```

The translation is *functional*: there are no pointers and no heap in the
Lean code. That makes the proofs vastly simpler than in a separation-logic
tool, and it works because Rust's ownership discipline guarantees that a value
behind `&mut` cannot be observed by anyone else while it is borrowed. The price
is that Aeneas only supports *safe* Rust (no `unsafe`, no interior mutability)
and a subset of the standard library.

Four ideas carry the whole approach. Lesson 0 implements each one from scratch:

1. **Panics become values.** `fn f(..) -> T` becomes `f : .. → Result T`. An
   integer overflow, an out-of-bounds index or a `panic!()` is a `fail`.
   *Proving that `f x` returns `ok _` is proving it does not panic.*
2. **Specs are Hoare triples.** `f x ⦃ y => P y ⦄` means "`f x` succeeds and
   its result satisfies `P`".
3. **`&mut` becomes "input + backward function".** Borrowing `&mut v[i]`
   yields the value *and* a function `back : U64 → Vec U64` that rebuilds `v`
   with a new value at `i`. A function taking `&mut self` returns the updated
   `self`.
4. **Loops become recursive functions.** The loop invariant becomes a
   precondition of the function's spec, and termination is proved in the spec
   (`termination_by`).

---

## 2. The Rust code

Read [`rust/src/lib.rs`](rust/src/lib.rs) first. It is short and heavily
commented. The model:

* `Ledger { balances: Vec<u64>, treasury: usize }`: one balance per account,
  in minor units (cents). Account `treasury` collects the fees.
* `FeePolicy { flat, rate_bps }`: the fee is `flat + amount * rate_bps / 10_000`
  (1 bps = 0.01 %).
* `quote(policy, amount) -> Result<Quote, RemitError>`: prices a transfer.
* `Ledger::transfer(&mut self, policy, sender, receiver, amount)`: validates,
  quotes, then moves the money.
* `Ledger::deposit`, `Ledger::total_supply`.

**The ledger invariant** (`Ledger.Inv` in Lean) is stated in a doc comment,
because Rust's type system cannot express it:

1. `treasury < balances.len()`;
2. the sum of all balances fits in a `u64`.

Look at `transfer` with this in mind. `self.balances[receiver] += q.amount`
*could* overflow, and `self.balances[treasury]` *could* be out of bounds. The
code is still correct, because neither can happen on a ledger that satisfies
the invariant. Proving that is the most interesting part of Lesson 4.

The code avoids features that make the Lean translation noisier: no
`#[derive]`, no traits of our own, no closures or iterators, no `?` (an
explicit `match` instead). Aeneas supports many of these, but each one pulls
extra standard-library models into the generated code. Start simple.

```sh
make test          # cargo test
```

---

## 3. Setup

Versions are pinned. Aeneas moves fast, and the generated code, the library
and the tactics have to come from the same commit.

| Tool | Version | Where it is pinned |
|---|---|---|
| Lean | `v4.35.0` | `lean/lean-toolchain` |
| Aeneas (binary and Lean library) | commit `698a3360` (2026-11-08) | `lean/lakefile.lean` |
| Charon | commit `454586e9` | `charon-pin` in the Aeneas repository |
| Rust nightly (for Charon only) | `nightly-2026-09-17` | `rust-toolchain` in the Charon repository |

```sh
# Lean, through elan (or: nix profile add nixpkgs#lean4)
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh

# Aeneas (needs OCaml 5 + opam) and Charon (needs rustup)
git clone https://github.com/AeneasVerif/aeneas && cd aeneas
git checkout 698a336018637d5e0ba893aefbe0d0ea042ecaa3
opam install src --deps-only
make setup-charon        # clones + builds Charon at the pinned commit
make                     # builds bin/aeneas
export PATH="$PWD/bin:$PWD/charon/bin:$PATH"
```

Then, from this folder:

```sh
make lesson0       # Lesson 0 + Math.lean: needs only `lean`, takes a second
make extract       # regenerate lean/Remittance/Code/*.lean from the Rust code
make proofs        # cd lean && lake build  (the first run fetches Mathlib's cache)
```

Use an editor with the Lean extension (VS Code + `lean4`) and **step through
the proofs**. Put your cursor after each tactic and read the goal. That is how
Lean proofs are meant to be read; the text alone does not tell you much.

---

## Lesson 0: the ideas, from scratch (`Remittance/FromScratch.lean`)

*Checked. No dependencies: `lean Remittance/FromScratch.lean`.*

Before using Aeneas, we rebuild a miniature of it in ~400 lines of plain Lean.

**Panics as values.** `Result α` is `ok a | fail e` and is a monad, so in a
`do` block `let x ← e` stops at the first `fail`, the way a panic unwinds.
`U64` is a `Nat` with a proof that it is `≤ 2^64 - 1`, and `x + y : Result U64`
fails on overflow, as in a Rust debug build.

**Translation.** Every operation that may panic gets its own `let … ←`:

```rust
amount * rate_bps / 10_000
```
```lean
def proportional_fee_naive (amount rate_bps : U64) : Result U64 := do
  let i ← amount * rate_bps
  i / U64.ofNat 10000
```

**Running the bug.** Lean evaluates the function and finds the overflow:

```lean
theorem proportional_fee_naive_overflows :
    proportional_fee_naive (U64.ofNat 200000000000000000) (U64.ofNat 100)
      = fail .integerOverflow := by rfl
```

**Specs and `spec_bind`.** `r ⦃ x => P x ⦄` means `r = ok x` with `P x`. The
key rule is

```lean
theorem spec_bind (hm : m.spec P) (hk : ∀ a, P a → (k a).spec Q) :
    (m >>= k).spec Q
```

To prove something about `let a ← m; k a`, use a spec of `m`, then continue
with `k a`, knowing `P a`. **This is all that Aeneas' `step` tactic does**,
plus a database of specs and automatic discharge of their preconditions. In
`proportional_fee_naive_spec` you apply it by hand, twice.

**Backward functions.** `index_mut v i` returns `(v[i], fun x => v.set i x)`.
`pay` (move `amount` from `src` to `dst`) uses it twice, and `pay_spec` proves
that it does not panic and **conserves money**, provided:

* `src ≠ dst`, both in bounds, and `amount ≤ balance[src]`;
* `supply l ≤ U64.max`: the supply invariant. Without it, `balances[dst] +=
  amount` could overflow. With it, `balance[dst] + amount ≤ balance[dst] +
  balance[src] ≤ supply ≤ U64.max`.

**Loops.** `total_supply_loop` is the `while` loop as a recursive function,
and `total_supply_loop_spec` has the loop invariant
`total = supply (l.take i)` as a precondition. It is proved by recursion on
itself, with `termination_by l.length - i`.

**Composition.** `pay_preserves_total_supply` runs `total_supply; pay;
total_supply` as one program and proves both totals equal. It uses only the
specs, never the function bodies. Proofs compose because specs compose.

> **Exercises (Lesson 0)**
> 1. Prove that `pay l i i amount` (same account) also conserves the supply.
>    Which hypothesis of `pay_spec` can you drop?
> 2. State and prove: if `l[src].val < amount.val` then `pay` fails.
> 3. `U64.ofNat 0` appears in `total_supply`. Why does the precondition
>    `total.val = supply (l.take 0)` hold? Make the proof explicit.

---

## Lesson 1: arithmetic, overflow and casts (`Proofs/Fee.lean`)

Now the real thing. Open `Remittance/Code/Funs.lean` and compare it with the
Rust code. Aeneas' encoding has the same shape as Lesson 0's:

```lean
def proportional_fee (amount : Std.U64) (rate_bps : Std.U64) : Result Std.U64 := do
  let i ← lift (UScalar.cast .U128 amount)
  let i1 ← lift (UScalar.cast .U128 rate_bps)
  let i2 ← i * i1
  let wide ← i2 / 10000#u128
  ok (UScalar.cast .U64 wide)
```

* `Std.U64`, `Std.U128` are `UScalar .U64` and so on. `x.val : Nat` is the
  value, `U64.max = 2^64 - 1`, and `10000#u128` is a literal.
* `i * i1 : Result U128`: checked arithmetic, as in Lesson 0.
* `lift` wraps a pure expression (a cast cannot panic) into `Result`.
* `UScalar.cast .U64 wide` is Rust's `as u64`. It **truncates**: its value is
  `wide.val % 2^64`.

The spec:

```lean
@[step]
theorem proportional_fee_spec (amount rate_bps : U64) (h : rate_bps.val ≤ 10000) :
    proportional_fee amount rate_bps
      ⦃ fee => fee.val = amount.val * rate_bps.val / 10000 ∧ fee.val ≤ amount.val ⦄
```

The proof is `unfold proportional_fee` and then `step*`. `step` applies the
`@[step]` specs of `*` and `/` (`U128.mul_spec`, `U128.div_spec`) and
discharges their preconditions with `scalar_tac`, Aeneas' arithmetic
decision procedure. The `have` lines before it provide the facts that
`scalar_tac` cannot find alone: the product needs a nonlinear bound.

Why is `h` needed? The cast. Without `rate_bps ≤ 10_000` the quotient can
exceed `u64::MAX` and `as u64` silently truncates. The Rust test
`proportional_fee_truncates_above_100_percent` demonstrates it. The proof
would not go through, and that is how a verifier tells you a spec is false.

`@[step]` registers the theorem, so later proofs (`quote`) use it
automatically.

> **Exercises (Lesson 1)**
> 1. In `proportional_fee_naive_spec`, delete `h` and look at the goal `step`
>    leaves you. Find the input that makes it false (Lesson 0 has one).
> 2. Prove a spec of `proportional_fee` with **no** hypothesis:
>    `fee.val = (amount.val * rate_bps.val / 10000) % 2^64`.
> 3. Change the Rust code to round *up* (`(a * r + 9_999) / 10_000`),
>    regenerate, and update the spec. Can the `u128` addition overflow?

---

## Lesson 2: total specs for `Result<_, _>` (`Proofs/Fee.lean`)

`quote` returns a Rust `Result<Quote, RemitError>`. In Lean that is
`core.result.Result Quote RemitError`, nested *inside* Aeneas' `Result`:

```
Result (core.result.Result Quote RemitError)
^^^^^^  outer: did the code panic?
        ^^^^^^^^^^^^^^^^^^  inner: the Rust value, Ok or Err
```

Don't confuse the two. Returning `Err(RemitError::ZeroAmount)` is a perfectly
successful execution: `ok (.Err .ZeroAmount)`.

The spec of `quote` has **no precondition**. That makes it a *total*
specification: it says `quote` never panics, for any input, and it describes
each outcome:

```lean
theorem quote_spec (policy : FeePolicy) (amount : U64) :
    quote policy amount ⦃ r =>
      match r with
      | .Ok q => policy.rate_bps.val ≤ 10000 ∧ 0 < amount.val ∧ q.amount = amount ∧
                 q.fee.val = policy.flat.val + amount.val * policy.rate_bps.val / 10000 ∧
                 q.total.val = q.amount.val + q.fee.val
      | .Err .InvalidPolicy  => 10000 < policy.rate_bps.val
      | .Err .ZeroAmount     => amount.val = 0
      | .Err .AmountTooLarge => U64.max < amount.val + policy.flat.val + …
      | .Err _               => False ⦄
```

The last line says that `quote` never returns any *other* error. That is
easy to forget and easy to get wrong in tests.

`step*` follows every branch of the `if`s. Look at the Rust code and notice
that each `u64::MAX - x` is safe because `x ≤ u64::MAX`, and that each `+`
is safe because the `if` just before it checked. That is the reasoning
`scalar_tac` performs in each branch.

> **Exercises (Lesson 2)**
> 1. Add `q.fee.val ≤ policy.flat.val + q.amount.val` to the `.Ok` case.
> 2. Swap the two `AmountTooLarge` checks in the Rust code, regenerate, and
>    see which proof obligation changes.

---

## Lesson 3: loops (`Proofs/Supply.lean`)

With `-loops-to-rec` (see the `Makefile`), the `while` loop of `total_supply`
becomes

```lean
@[rust_loop]
def Ledger.total_supply_loop (self : Ledger) (total : Std.U64) (i : Std.Usize) :
    Result Std.U64 := do
  let i1 := alloc.vec.Vec.len self.balances
  if i < i1 then
    let i2 ← alloc.vec.Vec.index (core.slice.index.SliceIndexUsizeSlice Std.U64) self.balances i
    let total1 ← total + i2
    let i3 ← i + 1#usize
    Ledger.total_supply_loop self total1 i3
  else ok total
partial_fixpoint
```

`partial_fixpoint` lets Lean accept the definition **without** a termination
proof. A Rust loop may well not terminate, and the translation must not
pretend otherwise. You prove termination in the spec instead:

```lean
@[step]
theorem Ledger.total_supply_loop_spec (self : Ledger) (total : U64) (i : Usize)
    (hi : i.val ≤ self.balances.length)
    (hinv : total.val = supply (self.balances.val.take i.val))   -- the loop invariant
    (hsupply : supply self.balances.val ≤ U64.max) :             -- the ledger invariant
    Ledger.total_supply_loop self total i ⦃ r => r.val = supply self.balances.val ⦄ := by
  …
termination_by self.balances.length - i.val
decreasing_by scalar_decr_tac
```

The structure of the proof is that of the loop:

* **in the loop body** (`i < len`): the invariant plus `supply_take_succ`
  shows that `total + balances[i] = supply (take (i+1)) ≤ supply ≤ u64::MAX`,
  so there is no overflow. The invariant then holds at `i + 1`, and the
  recursive call is handled by *the theorem itself*;
* **at exit** (`i ≥ len`): `take i` is the whole list, so `total = supply`.

`supply` is defined in terms of `sumBy` from `Remittance/Math.lean`. Facts
about sums of lists live there, as plain Lean. They are reusable and fast to
check, and they do not depend on how Aeneas translates the code.

> **Exercises (Lesson 3)**
> 1. Make `total_supply` accumulate in a `u128` (`total += self.balances[i] as
>    u128`). Regenerate and prove it correct **without** `hsupply`. You will
>    need `i ≤ usize::MAX` to bound the sum by `usize::MAX * u64::MAX < 2^128`.
> 2. Rewrite the loop as `for b in self.balances.iter()` and regenerate *without*
>    `-loops-to-rec`. Compare the generated code (iterator models,
>    `loop`/`ControlFlow`) and try `loop.spec_decr_nat`.

---

## Lesson 4: state, frames, conservation (`Proofs/Ledger.lean`)

`transfer` takes `&mut self`, so its translation returns the new ledger:

```lean
def Ledger.transfer (self : Ledger) (policy : FeePolicy) (sender receiver : Std.Usize)
    (amount : Std.U64) : Result ((core.result.Result Quote RemitError) × Ledger)
```

and `self.balances[sender] -= q.total` becomes

```lean
let (i1, index_mut_back) ← alloc.vec.Vec.index_mut (…) self.balances sender
let i2 ← i1 - q.total
let v := index_mut_back i2          -- the backward function puts the new value back
```

The spec of `index_mut` says `index_mut_back = self.balances.set sender`, so
after the three updates the new balances are
`((balances.set sender _).set receiver _).set treasury _`. A spec about pairs
binds both components: `⦃ r self' => … ⦄`.

The main theorem says, for any inputs, on a ledger satisfying `Inv`:

```lean
self.transfer policy sender receiver amount ⦃ r self' =>
  self'.Inv ∧                                                   -- invariant preserved
  self'.treasury = self.treasury ∧
  supply self'.balances.val = supply self.balances.val ∧       -- CONSERVATION
  match r with
  | .Ok q  => q.amount = amount ∧ q.total.val = q.amount.val + q.fee.val ∧
              (sender loses total, receiver gains amount, treasury gains fee) ∧
              (∀ j ∉ {sender, receiver, treasury}, balance j unchanged)   -- frame
  | .Err _ => self' = self ⦄                                    -- failure is atomic
```

How the proof goes:

1. **The five validation `if`s.** Each early `return Err(..)` returns the
   *original* `self`, so each branch closes with `simp_all`. In Rust terms,
   all checks happen before the first write, so errors are atomic.
2. **`quote`.** Its spec from Lesson 2 is applied by `step`. On `Err` the
   ledger is again untouched.
3. **No overflow on credit.** The crux is `Math.add_le_sumBy`: two *distinct*
   balances add up to at most the supply. So
   `balance[receiver] + amount ≤ balance[receiver] + balance[sender] ≤ supply ≤ u64::MAX`.
   That is the only place where `sender ≠ receiver` and the supply invariant
   are needed, and it is exactly the argument behind the comment in the Rust
   code.
4. **Conservation.** `Math.sumBy_set_set_set` is the bookkeeping identity for
   three writes. With `new_s = s - (amount + fee)`, `new_r = r + amount` and
   `new_t = t + fee`, the supply is unchanged.

`deposit_spec` follows the same pattern and calls `total_supply_spec` from
Lesson 3. Finally `transfer_preserves_total_supply` composes the specs, as in
Lesson 0: running `total_supply; transfer; total_supply` yields equal numbers.

> **Exercises (Lesson 4)**
> 1. **Bug hunt.** In `lib.rs`, credit `q.total` to the receiver instead of
>    `q.amount`. Regenerate. Which proof breaks, and why does the overflow
>    argument fail before conservation does?
> 2. Remove the check `receiver == treasury` from the Rust code. Is the code
>    still correct? Regenerate and adapt the spec. Which lemma of `Math.lean`
>    stops applying, and what replaces it?
> 3. Add `fn process_batch(&mut self, policy: &FeePolicy, batch: &[(usize, usize, u64)]) -> u32`
>    that runs `transfer` on each entry and counts the successes. Prove that it
>    preserves `Inv` and the supply. (Loop + composition: everything from
>    Lessons 3 and 4.)
> 4. State a "no money is lost" theorem for the *treasury*: after `transfer`,
>    the treasury's balance never decreases.

---

## Cheat sheet: Rust → Lean (Aeneas)

| Rust | Lean (generated) |
|---|---|
| `u64`, `usize`, `u128` | `Std.U64`, `Std.Usize`, `Std.U128` (`x.val : Nat`) |
| `a + b` (may overflow) | `let c ← a + b` (fails on overflow) |
| `a as u128` | `lift (UScalar.cast .U128 a)` |
| `u64::MAX` | `core.num.U64.MAX` |
| `panic!()`, failed `assert!` | `fail panic`, `massert b` |
| `struct S { f: T }` | `structure S where f : T` |
| `enum E { A, B }` | `inductive E \| A \| B` |
| `Result<T, E>` (the Rust type) | `core.result.Result T E` (`.Ok`, `.Err`) |
| `Vec<T>` | `alloc.vec.Vec T` (`v.val : List T`, `v.length`) |
| `v.len()` | `alloc.vec.Vec.len v` |
| `v[i]` (read) | `alloc.vec.Vec.index (SliceIndexUsizeSlice T) v i` |
| `v[i] = x` / `v[i] += x` | `let (_, back) ← alloc.vec.Vec.index_mut … v i; let v' := back x` |
| `fn f(&self, ..)` | `def f (self : S) ..` |
| `fn f(&mut self, ..) -> R` | `def f (self : S) .. : Result (R × S)` |
| `while` loop | recursive `def …_loop … partial_fixpoint` (with `-loops-to-rec`) |

## Cheat sheet: tactics

| Tactic | Use it for |
|---|---|
| `unfold f` | expose the body of `f` |
| `step` / `step as ⟨x, h⟩` | apply the `@[step]` spec of the next monadic call |
| `step*` | `step` repeatedly, splitting on `if`/`match` |
| `step with thm` | use a specific spec |
| `scalar_tac` | linear arithmetic over `Nat`/`Int`/machine integers (knows `U64.max`, …) |
| `scalar_tac +nonLin` | the same, with some nonlinear reasoning |
| `simp_lists` | `List.set`/indexing simplifications (`(l.set i x)[j]` with `i ≠ j`, …) |
| `simp_all`, `agrind` | general clean-up |
| `termination_by m` / `decreasing_by scalar_decr_tac` | recursive specs of loops |

The Aeneas repository's
[`documentation/`](https://github.com/AeneasVerif/aeneas/tree/main/documentation)
folder has a full tactics reference and proof strategies.

---

## Where to go next

* The Aeneas tutorial: `tests/src/tutorial` (Rust) and `tests/lean/Tutorial/`
  (`Exercises.lean`, `Solutions.lean`) in the Aeneas repository.
* The larger verified examples in the same folder: `Hashmap/`, `Avl/`, `Bst/`.
* Son Ho and Jonathan Protzenko, *Aeneas: Rust Verification by Functional
  Translation* (ICFP 2022), and Son Ho, Aymeric Fromherz, Jonathan Protzenko,
  *Sound Borrow-Checking for Rust via Symbolic Semantics* (ICFP 2024).
* *Theorem Proving in Lean 4* and *Functional Programming in Lean* (the Lean
  docs) if the Lean side feels unfamiliar.
