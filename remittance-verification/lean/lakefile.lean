import Lake
open Lake DSL

/-
  The Aeneas Lean library: the `Result` monad, the Rust scalar types (`U64`,
  `Usize`, ...), models of `Vec`, slices and `core::result::Result`, and the
  proof tactics (`step`, `scalar_tac`, `simp_lists`, ...). It pulls in Mathlib.

  The commit must match the `aeneas` binary used to (re)generate
  `Remittance/Code/*.lean`; see `../README.md`, "Regenerating the Lean code".
-/
require aeneas from git
  "https://github.com/AeneasVerif/aeneas" @ "698a336018637d5e0ba893aefbe0d0ea042ecaa3" / "backends/lean"

package «remittance» where
  leanOptions := #[⟨`autoImplicit, false⟩]

@[default_target]
lean_lib «Remittance» {}
