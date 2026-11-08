# Study case: verifying a Rust remittance ledger in Lean with Aeneas.
#
#   make test      run the Rust unit tests
#   make lesson0   check the dependency-free Lean files (only needs `lean`)
#   make extract   Rust -> LLBC (charon) -> Lean (aeneas); needs both on PATH
#   make proofs    build the Lean project, including all proofs (needs lake)
#   make all       test + extract + proofs

CHARON ?= charon
AENEAS ?= aeneas
LEAN   ?= lean

LLBC := rust/remittance.llbc

.PHONY: all test lesson0 extract proofs clean

all: test extract proofs

test:
	cd rust && cargo test

lesson0:
	cd lean && $(LEAN) Remittance/FromScratch.lean && $(LEAN) Remittance/Math.lean
	@echo "Lesson 0 and Math.lean check."

# 1. Charon compiles the crate with rustc and dumps its MIR as LLBC.
$(LLBC): rust/src/lib.rs rust/Cargo.toml
	cd rust && $(CHARON) cargo --preset=aeneas --dest-file remittance.llbc

# 2. Aeneas turns the LLBC into Lean. `-loops-to-rec` turns `while` loops
#    into recursive functions, which are the easiest to reason about.
extract: $(LLBC)
	$(AENEAS) -backend lean $(LLBC) -dest lean -subdir Remittance/Code \
	  -split-files -loops-to-rec
	@echo "Regenerated lean/Remittance/Code/{Types,Funs}.lean; review with 'git diff'."

proofs:
	cd lean && lake build

clean:
	rm -f $(LLBC)
	cd rust && cargo clean
