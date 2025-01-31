	.text
	.file	"main.ed9e37ee-cgu.0"
	.section	.text._ZN3std10sys_common9backtrace28__rust_begin_short_backtrace17h22b72b8c2013c45cE,"ax",@progbits
	.p2align	4, 0x90
	.type	std::sys_common::backtrace::__rust_begin_short_backtrace::h22b72b8c2013c45c,@function
std::sys_common::backtrace::__rust_begin_short_backtrace::h22b72b8c2013c45c:
.Lfunc_begin0:
	.file	1 "/build/rustc-1.65.0-src/library/std/src/sys_common/backtrace.rs"
	.loc	1 118 0
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
.Ltmp0:
	.file	2 "/build/rustc-1.65.0-src/library/core/src/ops/function.rs"
	.loc	2 248 5 prologue_end
	callq	*%rdi
.Ltmp1:
	.file	3 "/build/rustc-1.65.0-src/library/core/src/hint.rs"
	.loc	3 223 5
	#APP
	#NO_APP
.Ltmp2:
	.loc	1 128 2
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Ltmp3:
.Lfunc_end0:
	.size	std::sys_common::backtrace::__rust_begin_short_backtrace::h22b72b8c2013c45c, .Lfunc_end0-std::sys_common::backtrace::__rust_begin_short_backtrace::h22b72b8c2013c45c
	.cfi_endproc

	.section	.text._ZN3std2rt10lang_start17hec7bce37f31bbd41E,"ax",@progbits
	.hidden	std::rt::lang_start::hec7bce37f31bbd41
	.globl	std::rt::lang_start::hec7bce37f31bbd41
	.p2align	4, 0x90
	.type	std::rt::lang_start::hec7bce37f31bbd41,@function
std::rt::lang_start::hec7bce37f31bbd41:
.Lfunc_begin1:
	.file	4 "/build/rustc-1.65.0-src/library/std/src/rt.rs"
	.loc	4 159 0
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	%ecx, %r8d
	movq	%rdx, %rcx
.Ltmp4:
	movq	%rsi, %rdx
.Ltmp5:
	.loc	4 166 10 prologue_end
	movq	%rdi, (%rsp)
	.loc	4 165 17
	leaq	.L__unnamed_1(%rip), %rsi
.Ltmp6:
	.loc	4 0 17 is_stmt 0
	movq	%rsp, %rdi
.Ltmp7:
	.loc	4 165 17
	callq	*std::rt::lang_start_internal::h0b59928b60b7c3a2@GOTPCREL(%rip)
.Ltmp8:
	.loc	4 175 2 is_stmt 1
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Ltmp9:
.Lfunc_end1:
	.size	std::rt::lang_start::hec7bce37f31bbd41, .Lfunc_end1-std::rt::lang_start::hec7bce37f31bbd41
	.cfi_endproc

	.section	".text._ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17hfe18453754041a95E","ax",@progbits
	.p2align	4, 0x90
	.type	std::rt::lang_start::{{closure}}::hfe18453754041a95,@function
std::rt::lang_start::{{closure}}::hfe18453754041a95:
.Lfunc_begin2:
	.loc	4 166 0
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
.Ltmp10:
	.loc	4 166 77 prologue_end
	movq	(%rdi), %rdi
.Ltmp11:
	.loc	4 166 18 is_stmt 0
	callq	std::sys_common::backtrace::__rust_begin_short_backtrace::h22b72b8c2013c45c
	.loc	4 166 100
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Ltmp12:
.Lfunc_end2:
	.size	std::rt::lang_start::{{closure}}::hfe18453754041a95, .Lfunc_end2-std::rt::lang_start::{{closure}}::hfe18453754041a95
	.cfi_endproc

	.section	".text._ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17hd0944ab9ee7fa202E","ax",@progbits
	.p2align	4, 0x90
	.type	core::ops::function::FnOnce::call_once{{vtable.shim}}::hd0944ab9ee7fa202,@function
core::ops::function::FnOnce::call_once{{vtable.shim}}::hd0944ab9ee7fa202:
.Lfunc_begin3:
	.loc	2 248 0 is_stmt 1
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
.Ltmp13:
	.loc	2 248 5 prologue_end
	movq	(%rdi), %rdi
.Ltmp14:
	.loc	4 166 18
	callq	std::sys_common::backtrace::__rust_begin_short_backtrace::h22b72b8c2013c45c
.Ltmp15:
	.loc	2 248 5
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Ltmp16:
.Lfunc_end3:
	.size	core::ops::function::FnOnce::call_once{{vtable.shim}}::hd0944ab9ee7fa202, .Lfunc_end3-core::ops::function::FnOnce::call_once{{vtable.shim}}::hd0944ab9ee7fa202
	.cfi_endproc

	.section	".text._ZN4core3ptr85drop_in_place$LT$std..rt..lang_start$LT$$LP$$RP$$GT$..$u7b$$u7b$closure$u7d$$u7d$$GT$17h1d89ef1bc4b12bd0E","ax",@progbits
	.p2align	4, 0x90
	.type	core::ptr::drop_in_place<std::rt::lang_start<()>::{{closure}}>::h1d89ef1bc4b12bd0,@function
core::ptr::drop_in_place<std::rt::lang_start<()>::{{closure}}>::h1d89ef1bc4b12bd0:
.Lfunc_begin4:
	.file	5 "/build/rustc-1.65.0-src/library/core/src/ptr/mod.rs"
	.loc	5 487 0
	.cfi_startproc
	.loc	5 487 1 prologue_end
	retq
.Ltmp17:
.Lfunc_end4:
	.size	core::ptr::drop_in_place<std::rt::lang_start<()>::{{closure}}>::h1d89ef1bc4b12bd0, .Lfunc_end4-core::ptr::drop_in_place<std::rt::lang_start<()>::{{closure}}>::h1d89ef1bc4b12bd0
	.cfi_endproc

	.section	.text._ZN4main4main17h8a621b93f5f3e9cdE,"ax",@progbits
	.p2align	4, 0x90
	.type	main::main::h8a621b93f5f3e9cd,@function
main::main::h8a621b93f5f3e9cd:
.Lfunc_begin5:
	.file	6 "/home/ardfard/code/rustplay/src/main.rs"
	.loc	6 20 0
	.cfi_startproc
	subq	$72, %rsp
	.cfi_def_cfa_offset 80
	movabsq	$4638989091168321536, %rax
.Ltmp18:
	.loc	6 21 13 prologue_end
	movq	%rax, (%rsp)
	movq	%rsp, %rax
.Ltmp19:
	.loc	6 22 5
	movq	%rax, 8(%rsp)
	movq	core::fmt::float::<impl core::fmt::Display for f64>::fmt::h971348a10ef8785a@GOTPCREL(%rip), %rax
	movq	%rax, 16(%rsp)
.Ltmp20:
	.file	7 "/build/rustc-1.65.0-src/library/core/src/fmt/mod.rs"
	.loc	7 398 9
	leaq	.L__unnamed_2(%rip), %rax
.Ltmp21:
	movq	%rax, 24(%rsp)
	movq	$2, 32(%rsp)
	movq	$0, 40(%rsp)
	leaq	8(%rsp), %rax
.Ltmp22:
	movq	%rax, 56(%rsp)
	movq	$1, 64(%rsp)
	leaq	24(%rsp), %rdi
.Ltmp23:
	.loc	6 22 5
	callq	*std::io::stdio::_print::h5344a9ecf76e0cb5@GOTPCREL(%rip)
.Ltmp24:
	.loc	6 23 2
	addq	$72, %rsp
	.cfi_def_cfa_offset 8
	retq
.Ltmp25:
.Lfunc_end5:
	.size	main::main::h8a621b93f5f3e9cd, .Lfunc_end5-main::main::h8a621b93f5f3e9cd
	.cfi_endproc

	.section	.text.main,"ax",@progbits
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:
.Lfunc_begin6:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rsi, %rcx
	movq	__rustc_debug_gdb_scripts_section__@GOTPCREL(%rip), %rax
	movb	(%rax), %al
	movslq	%edi, %rdx
	leaq	main::main::h8a621b93f5f3e9cd(%rip), %rax
	movq	%rax, (%rsp)
	leaq	.L__unnamed_1(%rip), %rsi
	movq	%rsp, %rdi
	movl	$2, %r8d
	callq	*std::rt::lang_start_internal::h0b59928b60b7c3a2@GOTPCREL(%rip)
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end6:
	.size	main, .Lfunc_end6-main
	.cfi_endproc

	.type	.L__unnamed_1,@object
	.section	.data.rel.ro..L__unnamed_1,"aw",@progbits
	.p2align	3
.L__unnamed_1:
	.quad	core::ptr::drop_in_place<std::rt::lang_start<()>::{{closure}}>::h1d89ef1bc4b12bd0
	.asciz	"\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	core::ops::function::FnOnce::call_once{{vtable.shim}}::hd0944ab9ee7fa202
	.quad	std::rt::lang_start::{{closure}}::hfe18453754041a95
	.quad	std::rt::lang_start::{{closure}}::hfe18453754041a95
	.size	.L__unnamed_1, 48

	.type	.L__unnamed_3,@object
	.section	.rodata.cst4,"aM",@progbits,4
.L__unnamed_3:
	.ascii	"tst "
	.size	.L__unnamed_3, 4

	.type	.L__unnamed_4,@object
	.section	.rodata..L__unnamed_4,"a",@progbits
.L__unnamed_4:
	.byte	10
	.size	.L__unnamed_4, 1

	.type	.L__unnamed_2,@object
	.section	.data.rel.ro..L__unnamed_2,"aw",@progbits
	.p2align	3
.L__unnamed_2:
	.quad	.L__unnamed_3
	.asciz	"\004\000\000\000\000\000\000"
	.quad	.L__unnamed_4
	.asciz	"\001\000\000\000\000\000\000"
	.size	.L__unnamed_2, 32

	.type	__rustc_debug_gdb_scripts_section__,@object
	.section	.debug_gdb_scripts,"aMS",@progbits,1,unique,1
	.weak	__rustc_debug_gdb_scripts_section__
__rustc_debug_gdb_scripts_section__:
	.asciz	"\001gdb_load_rust_pretty_printers.py"
	.size	__rustc_debug_gdb_scripts_section__, 34

	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.quad	-1
	.quad	.Lfunc_begin0
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp1-.Lfunc_begin0
	.short	1
	.byte	85
	.quad	.Ltmp1-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	4
	.byte	243
	.byte	1
	.byte	85
	.byte	159
	.quad	0
	.quad	0
.Ldebug_loc1:
	.quad	-1
	.quad	.Lfunc_begin1
	.quad	.Lfunc_begin1-.Lfunc_begin1
	.quad	.Ltmp7-.Lfunc_begin1
	.short	1
	.byte	85
	.quad	.Ltmp7-.Lfunc_begin1
	.quad	.Lfunc_end1-.Lfunc_begin1
	.short	4
	.byte	243
	.byte	1
	.byte	85
	.byte	159
	.quad	0
	.quad	0
.Ldebug_loc2:
	.quad	-1
	.quad	.Lfunc_begin1
	.quad	.Lfunc_begin1-.Lfunc_begin1
	.quad	.Ltmp6-.Lfunc_begin1
	.short	1
	.byte	84
	.quad	.Ltmp6-.Lfunc_begin1
	.quad	.Ltmp8-.Lfunc_begin1
	.short	1
	.byte	81
	.quad	.Ltmp8-.Lfunc_begin1
	.quad	.Lfunc_end1-.Lfunc_begin1
	.short	4
	.byte	243
	.byte	1
	.byte	84
	.byte	159
	.quad	0
	.quad	0
.Ldebug_loc3:
	.quad	-1
	.quad	.Lfunc_begin1
	.quad	.Lfunc_begin1-.Lfunc_begin1
	.quad	.Ltmp5-.Lfunc_begin1
	.short	1
	.byte	81
	.quad	.Ltmp5-.Lfunc_begin1
	.quad	.Ltmp8-.Lfunc_begin1
	.short	1
	.byte	82
	.quad	.Ltmp8-.Lfunc_begin1
	.quad	.Lfunc_end1-.Lfunc_begin1
	.short	4
	.byte	243
	.byte	1
	.byte	81
	.byte	159
	.quad	0
	.quad	0
.Ldebug_loc4:
	.quad	-1
	.quad	.Lfunc_begin1
	.quad	.Lfunc_begin1-.Lfunc_begin1
	.quad	.Ltmp4-.Lfunc_begin1
	.short	1
	.byte	82
	.quad	.Ltmp4-.Lfunc_begin1
	.quad	.Ltmp8-.Lfunc_begin1
	.short	1
	.byte	88
	.quad	.Ltmp8-.Lfunc_begin1
	.quad	.Lfunc_end1-.Lfunc_begin1
	.short	4
	.byte	243
	.byte	1
	.byte	82
	.byte	159
	.quad	0
	.quad	0
.Ldebug_loc5:
	.quad	-1
	.quad	.Lfunc_begin2
	.quad	.Ltmp10-.Lfunc_begin2
	.quad	.Ltmp11-.Lfunc_begin2
	.short	2
	.byte	117
	.byte	0
	.quad	0
	.quad	0
.Ldebug_loc6:
	.quad	-1
	.quad	.Lfunc_begin3
	.quad	.Lfunc_begin3-.Lfunc_begin3
	.quad	.Ltmp14-.Lfunc_begin3
	.short	1
	.byte	85
	.quad	.Ltmp14-.Lfunc_begin3
	.quad	.Lfunc_end3-.Lfunc_begin3
	.short	4
	.byte	243
	.byte	1
	.byte	85
	.byte	159
	.quad	0
	.quad	0
.Ldebug_loc7:
	.quad	-1
	.quad	.Lfunc_begin5
	.quad	.Ltmp20-.Lfunc_begin5
	.quad	.Ltmp21-.Lfunc_begin5
	.short	6
	.byte	147
	.byte	8
	.byte	50
	.byte	159
	.byte	147
	.byte	8
	.quad	.Ltmp21-.Lfunc_begin5
	.quad	.Ltmp22-.Lfunc_begin5
	.short	7
	.byte	80
	.byte	147
	.byte	8
	.byte	50
	.byte	159
	.byte	147
	.byte	8
	.quad	.Ltmp22-.Lfunc_begin5
	.quad	.Lfunc_end5-.Lfunc_begin5
	.short	6
	.byte	147
	.byte	8
	.byte	50
	.byte	159
	.byte	147
	.byte	8
	.quad	0
	.quad	0
.Ldebug_loc8:
	.quad	-1
	.quad	.Lfunc_begin5
	.quad	.Ltmp20-.Lfunc_begin5
	.quad	.Lfunc_end5-.Lfunc_begin5
	.short	9
	.byte	119
	.byte	8
	.byte	159
	.byte	147
	.byte	8
	.byte	49
	.byte	159
	.byte	147
	.byte	8
	.quad	0
	.quad	0
	.section	.debug_abbrev,"",@progbits
	.byte	1
	.byte	17
	.byte	1
	.byte	37
	.byte	14
	.byte	19
	.byte	5
	.byte	3
	.byte	14
	.byte	16
	.byte	23
	.byte	27
	.byte	14
	.ascii	"\264B"
	.byte	25
	.byte	17
	.byte	1
	.byte	85
	.byte	23
	.byte	0
	.byte	0
	.byte	2
	.byte	52
	.byte	0
	.byte	3
	.byte	14
	.byte	73
	.byte	19
	.byte	2
	.byte	24
	.byte	0
	.byte	0
	.byte	3
	.byte	19
	.byte	1
	.byte	29
	.byte	19
	.byte	3
	.byte	14
	.byte	11
	.byte	11
	.ascii	"\210\001"
	.byte	15
	.byte	0
	.byte	0
	.byte	4
	.byte	13
	.byte	0
	.byte	3
	.byte	14
	.byte	73
	.byte	19
	.ascii	"\210\001"
	.byte	15
	.byte	56
	.byte	11
	.byte	0
	.byte	0
	.byte	5
	.byte	15
	.byte	0
	.byte	73
	.byte	19
	.byte	3
	.byte	14
	.byte	51
	.byte	6
	.byte	0
	.byte	0
	.byte	6
	.byte	36
	.byte	0
	.byte	3
	.byte	14
	.byte	62
	.byte	11
	.byte	11
	.byte	11
	.byte	0
	.byte	0
	.byte	7
	.byte	57
	.byte	1
	.byte	3
	.byte	14
	.byte	0
	.byte	0
	.byte	8
	.byte	19
	.byte	1
	.byte	3
	.byte	14
	.byte	11
	.byte	11
	.ascii	"\210\001"
	.byte	15
	.byte	0
	.byte	0
	.byte	9
	.byte	46
	.byte	1
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	64
	.byte	24
	.byte	49
	.byte	19
	.byte	0
	.byte	0
	.byte	10
	.byte	52
	.byte	0
	.byte	2
	.byte	23
	.byte	49
	.byte	19
	.byte	0
	.byte	0
	.byte	11
	.byte	46
	.byte	1
	.byte	110
	.byte	14
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	73
	.byte	19
	.byte	32
	.byte	11
	.byte	0
	.byte	0
	.byte	12
	.byte	47
	.byte	0
	.byte	73
	.byte	19
	.byte	3
	.byte	14
	.byte	0
	.byte	0
	.byte	13
	.byte	52
	.byte	0
	.byte	3
	.byte	14
	.ascii	"\210\001"
	.byte	15
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	14
	.byte	46
	.byte	1
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	64
	.byte	24
	.byte	110
	.byte	14
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	15
	.byte	5
	.byte	0
	.byte	2
	.byte	23
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	16
	.byte	46
	.byte	1
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	64
	.byte	24
	.byte	110
	.byte	14
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	0
	.byte	0
	.byte	17
	.byte	29
	.byte	1
	.byte	49
	.byte	19
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	88
	.byte	11
	.byte	89
	.byte	11
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	18
	.byte	5
	.byte	0
	.byte	2
	.byte	24
	.byte	49
	.byte	19
	.byte	0
	.byte	0
	.byte	19
	.byte	11
	.byte	1
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	0
	.byte	0
	.byte	20
	.byte	52
	.byte	0
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	21
	.byte	29
	.byte	0
	.byte	49
	.byte	19
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	88
	.byte	11
	.byte	89
	.byte	11
	.byte	87
	.byte	11
	.byte	0
	.byte	0
	.byte	22
	.byte	21
	.byte	0
	.byte	0
	.byte	0
	.byte	23
	.byte	4
	.byte	1
	.byte	73
	.byte	19
	.byte	109
	.byte	25
	.byte	3
	.byte	14
	.byte	11
	.byte	11
	.ascii	"\210\001"
	.byte	15
	.byte	0
	.byte	0
	.byte	24
	.byte	40
	.byte	0
	.byte	3
	.byte	14
	.byte	28
	.byte	15
	.byte	0
	.byte	0
	.byte	25
	.byte	51
	.byte	1
	.byte	21
	.byte	19
	.byte	0
	.byte	0
	.byte	26
	.byte	13
	.byte	0
	.byte	73
	.byte	19
	.ascii	"\210\001"
	.byte	15
	.byte	56
	.byte	11
	.byte	52
	.byte	25
	.byte	0
	.byte	0
	.byte	27
	.byte	25
	.byte	1
	.byte	22
	.byte	11
	.byte	0
	.byte	0
	.byte	28
	.byte	19
	.byte	0
	.byte	3
	.byte	14
	.byte	11
	.byte	11
	.ascii	"\210\001"
	.byte	15
	.byte	0
	.byte	0
	.byte	29
	.byte	46
	.byte	1
	.byte	110
	.byte	14
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	5
	.byte	73
	.byte	19
	.byte	32
	.byte	11
	.byte	0
	.byte	0
	.byte	30
	.byte	5
	.byte	0
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	5
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	31
	.byte	46
	.byte	1
	.byte	110
	.byte	14
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	32
	.byte	11
	.byte	0
	.byte	0
	.byte	32
	.byte	5
	.byte	0
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	33
	.byte	5
	.byte	0
	.byte	2
	.byte	23
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	34
	.byte	46
	.byte	1
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	64
	.byte	24
	.byte	110
	.byte	14
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	5
	.byte	0
	.byte	0
	.byte	35
	.byte	5
	.byte	0
	.byte	2
	.byte	24
	.byte	58
	.byte	11
	.byte	59
	.byte	5
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	36
	.byte	25
	.byte	1
	.byte	0
	.byte	0
	.byte	37
	.byte	15
	.byte	0
	.byte	73
	.byte	19
	.byte	51
	.byte	6
	.byte	0
	.byte	0
	.byte	38
	.byte	21
	.byte	1
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	39
	.byte	5
	.byte	0
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	40
	.byte	1
	.byte	1
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	41
	.byte	33
	.byte	0
	.byte	73
	.byte	19
	.byte	34
	.byte	13
	.byte	55
	.byte	11
	.byte	0
	.byte	0
	.byte	42
	.byte	36
	.byte	0
	.byte	3
	.byte	14
	.byte	11
	.byte	11
	.byte	62
	.byte	11
	.byte	0
	.byte	0
	.byte	43
	.byte	46
	.byte	1
	.byte	17
	.byte	1
	.byte	18
	.byte	6
	.byte	64
	.byte	24
	.byte	110
	.byte	14
	.byte	3
	.byte	14
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	106
	.byte	25
	.byte	0
	.byte	0
	.byte	44
	.byte	52
	.byte	0
	.byte	28
	.byte	15
	.byte	3
	.byte	14
	.ascii	"\210\001"
	.byte	15
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	45
	.byte	5
	.byte	0
	.byte	2
	.byte	23
	.byte	49
	.byte	19
	.byte	0
	.byte	0
	.byte	46
	.byte	51
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.long	.Ldebug_info_end0-.Ldebug_info_start0
.Ldebug_info_start0:
	.short	4
	.long	.debug_abbrev
	.byte	8
	.byte	1
	.long	.Linfo_string0
	.short	28
	.long	.Linfo_string1
	.long	.Lline_table_start0
	.long	.Linfo_string2

	.quad	0
	.long	.Ldebug_ranges0
	.byte	2
	.long	.Linfo_string3
	.long	61
	.byte	9
	.byte	3
	.quad	.L__unnamed_1
	.byte	3
	.long	181
	.long	.Linfo_string19
	.byte	48
	.byte	8
	.byte	4
	.long	.Linfo_string4
	.long	139
	.byte	8
	.byte	0
	.byte	4
	.long	.Linfo_string7
	.long	159
	.byte	8
	.byte	8
	.byte	4
	.long	.Linfo_string9
	.long	159
	.byte	8
	.byte	16
	.byte	4
	.long	.Linfo_string10
	.long	139
	.byte	8
	.byte	24
	.byte	4
	.long	.Linfo_string11
	.long	139
	.byte	8
	.byte	32
	.byte	4
	.long	.Linfo_string12
	.long	139
	.byte	8
	.byte	40
	.byte	0
	.byte	5
	.long	152
	.long	.Linfo_string6
	.long	0
	.byte	6
	.long	.Linfo_string5
	.byte	7
	.byte	0
	.byte	6
	.long	.Linfo_string8
	.byte	7
	.byte	8
	.byte	7
	.long	.Linfo_string13
	.byte	7
	.long	.Linfo_string14
	.byte	7
	.long	.Linfo_string15
	.byte	8
	.long	.Linfo_string18
	.byte	8
	.byte	8
	.byte	4
	.long	.Linfo_string16
	.long	513
	.byte	8
	.byte	0
	.byte	0
	.byte	9
	.quad	.Lfunc_begin2
	.long	.Lfunc_end2-.Lfunc_begin2
	.byte	1
	.byte	87
	.long	229
	.byte	10
	.long	.Ldebug_loc5
	.long	254
	.byte	0
	.byte	11
	.long	.Linfo_string43
	.long	.Linfo_string44
	.byte	4
	.byte	166
	.long	1657
	.byte	1
	.byte	12
	.long	152
	.long	.Linfo_string37
	.byte	13
	.long	.Linfo_string16
	.byte	1
	.byte	4
	.byte	160
	.long	513
	.byte	0
	.byte	0
	.byte	14
	.quad	.Lfunc_begin1
	.long	.Lfunc_end1-.Lfunc_begin1
	.byte	1
	.byte	87
	.long	.Linfo_string106
	.long	.Linfo_string107
	.byte	4
	.byte	159
	.long	2129
	.byte	15
	.long	.Ldebug_loc1
	.long	.Linfo_string16
	.byte	4
	.byte	160
	.long	513
	.byte	15
	.long	.Ldebug_loc2
	.long	.Linfo_string114
	.byte	4
	.byte	161
	.long	2129
	.byte	15
	.long	.Ldebug_loc3
	.long	.Linfo_string115
	.byte	4
	.byte	162
	.long	2136
	.byte	15
	.long	.Ldebug_loc4
	.long	.Linfo_string118
	.byte	4
	.byte	163
	.long	1650
	.byte	12
	.long	152
	.long	.Linfo_string37
	.byte	0
	.byte	0
	.byte	7
	.long	.Linfo_string41
	.byte	7
	.long	.Linfo_string42
	.byte	16
	.quad	.Lfunc_begin0
	.long	.Lfunc_end0-.Lfunc_begin0
	.byte	1
	.byte	87
	.long	.Linfo_string104
	.long	.Linfo_string105
	.byte	1
	.byte	118
	.byte	15
	.long	.Ldebug_loc0
	.long	.Linfo_string113
	.byte	1
	.byte	118
	.long	513
	.byte	17
	.long	1009
	.quad	.Ltmp0
	.long	.Ltmp1-.Ltmp0
	.byte	1
	.byte	122
	.byte	18
	.byte	18
	.byte	1
	.byte	85
	.long	1039
	.byte	0
	.byte	19
	.quad	.Ltmp1
	.long	.Ltmp2-.Ltmp1
	.byte	20
	.long	.Linfo_string81
	.byte	1
	.byte	122
	.long	152
	.byte	21
	.long	1218
	.quad	.Ltmp1
	.long	.Ltmp2-.Ltmp1
	.byte	1
	.byte	125
	.byte	5
	.byte	0
	.byte	12
	.long	513
	.long	.Linfo_string103
	.byte	12
	.long	152
	.long	.Linfo_string37
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	5
	.long	526
	.long	.Linfo_string17
	.long	0
	.byte	22
	.byte	7
	.long	.Linfo_string20
	.byte	7
	.long	.Linfo_string21
	.byte	7
	.long	.Linfo_string14
	.byte	7
	.long	.Linfo_string22
	.byte	23
	.long	1650

	.long	.Linfo_string28
	.byte	1
	.byte	1
	.byte	24
	.long	.Linfo_string24
	.byte	0
	.byte	24
	.long	.Linfo_string25
	.byte	1
	.byte	24
	.long	.Linfo_string26
	.byte	2
	.byte	24
	.long	.Linfo_string27
	.byte	3
	.byte	0
	.byte	8
	.long	.Linfo_string71
	.byte	56
	.byte	8
	.byte	4
	.long	.Linfo_string57
	.long	159
	.byte	8
	.byte	0
	.byte	4
	.long	.Linfo_string58
	.long	613
	.byte	8
	.byte	8
	.byte	0
	.byte	8
	.long	.Linfo_string70
	.byte	48
	.byte	8
	.byte	4
	.long	.Linfo_string59
	.long	1788
	.byte	4
	.byte	32
	.byte	4
	.long	.Linfo_string9
	.long	547
	.byte	1
	.byte	40
	.byte	4
	.long	.Linfo_string61
	.long	1795
	.byte	4
	.byte	36
	.byte	4
	.long	.Linfo_string63
	.long	676
	.byte	8
	.byte	0
	.byte	4
	.long	.Linfo_string69
	.long	676
	.byte	8
	.byte	16
	.byte	0
	.byte	8
	.long	.Linfo_string68
	.byte	16
	.byte	8
	.byte	25
	.long	688
	.byte	26
	.long	1742
	.byte	8
	.byte	0

	.byte	27
	.byte	0
	.byte	4
	.long	.Linfo_string64
	.long	738
	.byte	8
	.byte	0
	.byte	0
	.byte	27
	.byte	1
	.byte	4
	.long	.Linfo_string66
	.long	757
	.byte	8
	.byte	0
	.byte	0
	.byte	27
	.byte	2
	.byte	4
	.long	.Linfo_string67
	.long	776
	.byte	8
	.byte	0
	.byte	0
	.byte	0
	.byte	8
	.long	.Linfo_string64
	.byte	16
	.byte	8
	.byte	4
	.long	.Linfo_string65
	.long	159
	.byte	8
	.byte	8
	.byte	0
	.byte	8
	.long	.Linfo_string66
	.byte	16
	.byte	8
	.byte	4
	.long	.Linfo_string65
	.long	159
	.byte	8
	.byte	8
	.byte	0
	.byte	28
	.long	.Linfo_string67
	.byte	16
	.byte	8
	.byte	0
	.byte	0
	.byte	0
	.byte	8
	.long	.Linfo_string100
	.byte	48
	.byte	8
	.byte	4
	.long	.Linfo_string49
	.long	1664
	.byte	8
	.byte	0
	.byte	4
	.long	.Linfo_string21
	.long	1309
	.byte	8
	.byte	16
	.byte	4
	.long	.Linfo_string75
	.long	1802
	.byte	8
	.byte	32
	.byte	29
	.long	.Linfo_string101
	.long	.Linfo_string102
	.byte	7
	.short	394
	.long	786
	.byte	1
	.byte	30
	.long	.Linfo_string49
	.byte	7
	.short	394
	.long	1664
	.byte	30
	.long	.Linfo_string75
	.byte	7
	.short	394
	.long	1802
	.byte	0
	.byte	0
	.byte	8
	.long	.Linfo_string98
	.byte	16
	.byte	8
	.byte	4
	.long	.Linfo_string76
	.long	1841
	.byte	8
	.byte	0
	.byte	4
	.long	.Linfo_string80
	.long	1854
	.byte	8
	.byte	8
	.byte	0
	.byte	7
	.long	.Linfo_string77
	.byte	28
	.long	.Linfo_string78
	.byte	0
	.byte	1
	.byte	0
	.byte	28
	.long	.Linfo_string83
	.byte	0
	.byte	1
	.byte	8
	.long	.Linfo_string95
	.byte	64
	.byte	8
	.byte	4
	.long	.Linfo_string61
	.long	1795
	.byte	4
	.byte	48
	.byte	4
	.long	.Linfo_string59
	.long	1788
	.byte	4
	.byte	52
	.byte	4
	.long	.Linfo_string9
	.long	547
	.byte	1
	.byte	56
	.byte	4
	.long	.Linfo_string69
	.long	1402
	.byte	8
	.byte	0
	.byte	4
	.long	.Linfo_string63
	.long	1402
	.byte	8
	.byte	16
	.byte	4
	.long	.Linfo_string88
	.long	1896
	.byte	8
	.byte	32
	.byte	0
	.byte	0
	.byte	7
	.long	.Linfo_string29
	.byte	7
	.long	.Linfo_string30
	.byte	7
	.long	.Linfo_string31
	.byte	31
	.long	.Linfo_string34
	.long	.Linfo_string35
	.byte	2
	.byte	248
	.byte	1
	.byte	12
	.long	513
	.long	.Linfo_string32
	.byte	12
	.long	152
	.long	.Linfo_string33
	.byte	32
	.byte	2
	.byte	248
	.long	513
	.byte	32
	.byte	2
	.byte	248
	.long	152
	.byte	0
	.byte	11
	.long	.Linfo_string46
	.long	.Linfo_string47
	.byte	2
	.byte	248
	.long	1657
	.byte	1
	.byte	12
	.long	181
	.long	.Linfo_string32
	.byte	12
	.long	152
	.long	.Linfo_string33
	.byte	32
	.byte	2
	.byte	248
	.long	181
	.byte	32
	.byte	2
	.byte	248
	.long	152
	.byte	0
	.byte	14
	.quad	.Lfunc_begin3
	.long	.Lfunc_end3-.Lfunc_begin3
	.byte	1
	.byte	87
	.long	.Linfo_string109
	.long	.Linfo_string47
	.byte	2
	.byte	248
	.long	1657
	.byte	33
	.long	.Ldebug_loc6
	.byte	2
	.byte	248
	.long	2162
	.byte	32
	.byte	2
	.byte	248
	.long	152
	.byte	17
	.long	1054
	.quad	.Ltmp14
	.long	.Ltmp15-.Ltmp14
	.byte	2
	.byte	248
	.byte	5
	.byte	21
	.long	229
	.quad	.Ltmp14
	.long	.Ltmp15-.Ltmp14
	.byte	2
	.byte	248
	.byte	5
	.byte	0
	.byte	12
	.long	181
	.long	.Linfo_string32
	.byte	12
	.long	152
	.long	.Linfo_string33
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	7
	.long	.Linfo_string36
	.byte	31
	.long	.Linfo_string38
	.long	.Linfo_string39
	.byte	3
	.byte	222
	.byte	1
	.byte	12
	.long	152
	.long	.Linfo_string37
	.byte	20
	.long	.Linfo_string40
	.byte	3
	.byte	222
	.long	152
	.byte	0
	.byte	0
	.byte	7
	.long	.Linfo_string48
	.byte	34
	.quad	.Lfunc_begin4
	.long	.Lfunc_end4-.Lfunc_begin4
	.byte	1
	.byte	87
	.long	.Linfo_string110
	.long	.Linfo_string111
	.byte	5
	.short	487
	.byte	35
	.byte	1
	.byte	85
	.byte	5
	.short	487
	.long	2162
	.byte	12
	.long	181
	.long	.Linfo_string37
	.byte	0
	.byte	0
	.byte	7
	.long	.Linfo_string54
	.byte	8
	.long	.Linfo_string74
	.byte	16
	.byte	8
	.byte	25
	.long	1321
	.byte	26
	.long	1742
	.byte	8
	.byte	0

	.byte	27
	.byte	0
	.byte	4
	.long	.Linfo_string56
	.long	1356
	.byte	8
	.byte	0
	.byte	0
	.byte	36
	.byte	4
	.long	.Linfo_string73
	.long	1373
	.byte	8
	.byte	0
	.byte	0
	.byte	0
	.byte	8
	.long	.Linfo_string56
	.byte	16
	.byte	8
	.byte	12
	.long	1749
	.long	.Linfo_string37
	.byte	0
	.byte	8
	.long	.Linfo_string73
	.byte	16
	.byte	8
	.byte	12
	.long	1749
	.long	.Linfo_string37
	.byte	4
	.long	.Linfo_string65
	.long	1749
	.byte	8
	.byte	0
	.byte	0
	.byte	0
	.byte	8
	.long	.Linfo_string87
	.byte	16
	.byte	8
	.byte	25
	.long	1414
	.byte	26
	.long	1742
	.byte	8
	.byte	0

	.byte	27
	.byte	0
	.byte	4
	.long	.Linfo_string56
	.long	1450
	.byte	8
	.byte	0
	.byte	0
	.byte	27
	.byte	1
	.byte	4
	.long	.Linfo_string73
	.long	1467
	.byte	8
	.byte	0
	.byte	0
	.byte	0
	.byte	8
	.long	.Linfo_string56
	.byte	16
	.byte	8
	.byte	12
	.long	159
	.long	.Linfo_string37
	.byte	0
	.byte	8
	.long	.Linfo_string73
	.byte	16
	.byte	8
	.byte	12
	.long	159
	.long	.Linfo_string37
	.byte	4
	.long	.Linfo_string65
	.long	159
	.byte	8
	.byte	8
	.byte	0
	.byte	0
	.byte	0
	.byte	7
	.long	.Linfo_string81
	.byte	8
	.long	.Linfo_string86
	.byte	1
	.byte	1
	.byte	25
	.long	1514
	.byte	26
	.long	1650
	.byte	1
	.byte	0

	.byte	27
	.byte	0
	.byte	4
	.long	.Linfo_string82
	.long	1550
	.byte	1
	.byte	0
	.byte	0
	.byte	27
	.byte	1
	.byte	4
	.long	.Linfo_string85
	.long	1587
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	8
	.long	.Linfo_string82
	.byte	1
	.byte	1
	.byte	12
	.long	152
	.long	.Linfo_string37
	.byte	12
	.long	912
	.long	.Linfo_string84
	.byte	4
	.long	.Linfo_string65
	.long	152
	.byte	1
	.byte	1
	.byte	0
	.byte	8
	.long	.Linfo_string85
	.byte	1
	.byte	1
	.byte	12
	.long	152
	.long	.Linfo_string37
	.byte	12
	.long	912
	.long	.Linfo_string84
	.byte	4
	.long	.Linfo_string65
	.long	912
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	7
	.long	.Linfo_string125
	.byte	8
	.long	.Linfo_string126
	.byte	0
	.byte	1
	.byte	12
	.long	2119
	.long	.Linfo_string37
	.byte	0
	.byte	0
	.byte	0
	.byte	6
	.long	.Linfo_string23
	.byte	7
	.byte	1
	.byte	6
	.long	.Linfo_string45
	.byte	5
	.byte	4
	.byte	8
	.long	.Linfo_string53
	.byte	16
	.byte	8
	.byte	4
	.long	.Linfo_string50
	.long	1694
	.byte	8
	.byte	0
	.byte	4
	.long	.Linfo_string51
	.long	159
	.byte	8
	.byte	8
	.byte	0
	.byte	37
	.long	1703
	.long	0
	.byte	8
	.long	.Linfo_string52
	.byte	16
	.byte	8
	.byte	4
	.long	.Linfo_string50
	.long	1733
	.byte	8
	.byte	0
	.byte	4
	.long	.Linfo_string51
	.long	159
	.byte	8
	.byte	8
	.byte	0
	.byte	37
	.long	1650
	.long	0
	.byte	6
	.long	.Linfo_string55
	.byte	7
	.byte	8
	.byte	8
	.long	.Linfo_string72
	.byte	16
	.byte	8
	.byte	4
	.long	.Linfo_string50
	.long	1779
	.byte	8
	.byte	0
	.byte	4
	.long	.Linfo_string51
	.long	159
	.byte	8
	.byte	8
	.byte	0
	.byte	37
	.long	583
	.long	0
	.byte	6
	.long	.Linfo_string60
	.byte	16
	.byte	4
	.byte	6
	.long	.Linfo_string62
	.byte	7
	.byte	4
	.byte	8
	.long	.Linfo_string99
	.byte	16
	.byte	8
	.byte	4
	.long	.Linfo_string50
	.long	1832
	.byte	8
	.byte	0
	.byte	4
	.long	.Linfo_string51
	.long	159
	.byte	8
	.byte	8
	.byte	0
	.byte	37
	.long	869
	.long	0
	.byte	5
	.long	904
	.long	.Linfo_string79
	.long	0
	.byte	5
	.long	1867
	.long	.Linfo_string97
	.long	0
	.byte	38
	.long	1502
	.byte	39
	.long	1841
	.byte	39
	.long	1883
	.byte	0
	.byte	5
	.long	919
	.long	.Linfo_string96
	.long	0
	.byte	8
	.long	.Linfo_string94
	.byte	16
	.byte	8
	.byte	4
	.long	.Linfo_string89
	.long	1926
	.byte	8
	.byte	0
	.byte	4
	.long	.Linfo_string91
	.long	1942
	.byte	8
	.byte	8
	.byte	0
	.byte	37
	.long	1935
	.long	0
	.byte	28
	.long	.Linfo_string90
	.byte	0
	.byte	1
	.byte	5
	.long	1955
	.long	.Linfo_string93
	.long	0
	.byte	40
	.long	159
	.byte	41
	.long	1968
	.byte	0
	.byte	3
	.byte	0
	.byte	42
	.long	.Linfo_string92
	.byte	8
	.byte	7
	.byte	7
	.long	.Linfo_string16
	.byte	43
	.quad	.Lfunc_begin5
	.long	.Lfunc_end5-.Lfunc_begin5
	.byte	1
	.byte	87
	.long	.Linfo_string112
	.long	.Linfo_string16
	.byte	6
	.byte	20

	.byte	19
	.quad	.Ltmp19
	.long	.Ltmp24-.Ltmp19
	.byte	44
	.ascii	"\200\200\200\200\200\200\300\260@"
	.long	.Linfo_string120
	.byte	1
	.byte	6
	.byte	21
	.long	2080
	.byte	17
	.long	826
	.quad	.Ltmp20
	.long	.Ltmp23-.Ltmp20
	.byte	6
	.byte	22
	.byte	5
	.byte	45
	.long	.Ldebug_loc7
	.long	843
	.byte	45
	.long	.Ldebug_loc8
	.long	855
	.byte	0
	.byte	0
	.byte	0
	.byte	8
	.long	.Linfo_string127
	.byte	8
	.byte	8
	.byte	12
	.long	2119
	.long	.Linfo_string122
	.byte	4
	.long	.Linfo_string65
	.long	2175
	.byte	8
	.byte	0
	.byte	4
	.long	.Linfo_string124
	.long	1631
	.byte	1
	.byte	0
	.byte	0
	.byte	8
	.long	.Linfo_string121
	.byte	0
	.byte	1
	.byte	46
	.byte	0
	.byte	0
	.byte	6
	.long	.Linfo_string108
	.byte	5
	.byte	8
	.byte	5
	.long	2149
	.long	.Linfo_string117
	.long	0
	.byte	5
	.long	1650
	.long	.Linfo_string116
	.long	0
	.byte	5
	.long	181
	.long	.Linfo_string119
	.long	0
	.byte	6
	.long	.Linfo_string123
	.byte	4
	.byte	8
	.byte	0
.Ldebug_info_end0:
	.section	.data.rel.ro..L__unnamed_1,"aw",@progbits
.Lsec_end0:
	.section	.text._ZN3std10sys_common9backtrace28__rust_begin_short_backtrace17h22b72b8c2013c45cE,"ax",@progbits
.Lsec_end1:
	.section	.text._ZN3std2rt10lang_start17hec7bce37f31bbd41E,"ax",@progbits
.Lsec_end2:
	.section	".text._ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17hfe18453754041a95E","ax",@progbits
.Lsec_end3:
	.section	".text._ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17hd0944ab9ee7fa202E","ax",@progbits
.Lsec_end4:
	.section	".text._ZN4core3ptr85drop_in_place$LT$std..rt..lang_start$LT$$LP$$RP$$GT$..$u7b$$u7b$closure$u7d$$u7d$$GT$17h1d89ef1bc4b12bd0E","ax",@progbits
.Lsec_end5:
	.section	.text._ZN4main4main17h8a621b93f5f3e9cdE,"ax",@progbits
.Lsec_end6:
	.section	.debug_aranges,"",@progbits
	.long	140
	.short	2
	.long	.Lcu_begin0
	.byte	8
	.byte	0
	.zero	4,255
	.quad	.L__unnamed_1
	.quad	.Lsec_end0-.L__unnamed_1
	.quad	.Lfunc_begin0
	.quad	.Lsec_end1-.Lfunc_begin0
	.quad	.Lfunc_begin1
	.quad	.Lsec_end2-.Lfunc_begin1
	.quad	.Lfunc_begin2
	.quad	.Lsec_end3-.Lfunc_begin2
	.quad	.Lfunc_begin3
	.quad	.Lsec_end4-.Lfunc_begin3
	.quad	.Lfunc_begin4
	.quad	.Lsec_end5-.Lfunc_begin4
	.quad	.Lfunc_begin5
	.quad	.Lsec_end6-.Lfunc_begin5
	.quad	0
	.quad	0
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.quad	.Lfunc_begin0
	.quad	.Lfunc_end0
	.quad	.Lfunc_begin1
	.quad	.Lfunc_end1
	.quad	.Lfunc_begin2
	.quad	.Lfunc_end2
	.quad	.Lfunc_begin3
	.quad	.Lfunc_end3
	.quad	.Lfunc_begin4
	.quad	.Lfunc_end4
	.quad	.Lfunc_begin5
	.quad	.Lfunc_end5
	.quad	0
	.quad	0
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"clang LLVM (rustc version 1.65.0)"
.Linfo_string1:
	.asciz	"src/main.rs/@/main.ed9e37ee-cgu.0"
.Linfo_string2:
	.asciz	"/home/ardfard/code/rustplay"
.Linfo_string3:
	.asciz	"<std::rt::lang_start::{closure_env#0}<()> as core::ops::function::Fn<()>>::{vtable}"
.Linfo_string4:
	.asciz	"drop_in_place"
.Linfo_string5:
	.asciz	"()"
.Linfo_string6:
	.asciz	"*const ()"
.Linfo_string7:
	.asciz	"size"
.Linfo_string8:
	.asciz	"usize"
.Linfo_string9:
	.asciz	"align"
.Linfo_string10:
	.asciz	"__method3"
.Linfo_string11:
	.asciz	"__method4"
.Linfo_string12:
	.asciz	"__method5"
.Linfo_string13:
	.asciz	"std"
.Linfo_string14:
	.asciz	"rt"
.Linfo_string15:
	.asciz	"lang_start"
.Linfo_string16:
	.asciz	"main"
.Linfo_string17:
	.asciz	"fn()"
.Linfo_string18:
	.asciz	"{closure_env#0}<()>"
.Linfo_string19:
	.asciz	"<std::rt::lang_start::{closure_env#0}<()> as core::ops::function::Fn<()>>::{vtable_type}"
.Linfo_string20:
	.asciz	"core"
.Linfo_string21:
	.asciz	"fmt"
.Linfo_string22:
	.asciz	"v1"
.Linfo_string23:
	.asciz	"u8"
.Linfo_string24:
	.asciz	"Left"
.Linfo_string25:
	.asciz	"Right"
.Linfo_string26:
	.asciz	"Center"
.Linfo_string27:
	.asciz	"Unknown"
.Linfo_string28:
	.asciz	"Alignment"
.Linfo_string29:
	.asciz	"ops"
.Linfo_string30:
	.asciz	"function"
.Linfo_string31:
	.asciz	"FnOnce"
.Linfo_string32:
	.asciz	"Self"
.Linfo_string33:
	.asciz	"Args"
.Linfo_string34:
	.asciz	"core::ops::function::FnOnce::call_once::h592cf2d4a11ede42"
.Linfo_string35:
	.asciz	"call_once<fn(), ()>"
.Linfo_string36:
	.asciz	"hint"
.Linfo_string37:
	.asciz	"T"
.Linfo_string38:
	.asciz	"core::hint::black_box::h3168feca3f5e0b02"
.Linfo_string39:
	.asciz	"black_box<()>"
.Linfo_string40:
	.asciz	"dummy"
.Linfo_string41:
	.asciz	"sys_common"
.Linfo_string42:
	.asciz	"backtrace"
.Linfo_string43:
	.asciz	"std::rt::lang_start::{{closure}}::hfe18453754041a95"
.Linfo_string44:
	.asciz	"{closure#0}<()>"
.Linfo_string45:
	.asciz	"i32"
.Linfo_string46:
	.asciz	"core::ops::function::FnOnce::call_once::hfed037d9302cb15d"
.Linfo_string47:
	.asciz	"call_once<std::rt::lang_start::{closure_env#0}<()>, ()>"
.Linfo_string48:
	.asciz	"ptr"
.Linfo_string49:
	.asciz	"pieces"
.Linfo_string50:
	.asciz	"data_ptr"
.Linfo_string51:
	.asciz	"length"
.Linfo_string52:
	.asciz	"&str"
.Linfo_string53:
	.asciz	"&[&str]"
.Linfo_string54:
	.asciz	"option"
.Linfo_string55:
	.asciz	"u64"
.Linfo_string56:
	.asciz	"None"
.Linfo_string57:
	.asciz	"position"
.Linfo_string58:
	.asciz	"format"
.Linfo_string59:
	.asciz	"fill"
.Linfo_string60:
	.asciz	"char"
.Linfo_string61:
	.asciz	"flags"
.Linfo_string62:
	.asciz	"u32"
.Linfo_string63:
	.asciz	"precision"
.Linfo_string64:
	.asciz	"Is"
.Linfo_string65:
	.asciz	"__0"
.Linfo_string66:
	.asciz	"Param"
.Linfo_string67:
	.asciz	"Implied"
.Linfo_string68:
	.asciz	"Count"
.Linfo_string69:
	.asciz	"width"
.Linfo_string70:
	.asciz	"FormatSpec"
.Linfo_string71:
	.asciz	"Argument"
.Linfo_string72:
	.asciz	"&[core::fmt::rt::v1::Argument]"
.Linfo_string73:
	.asciz	"Some"
.Linfo_string74:
	.asciz	"Option<&[core::fmt::rt::v1::Argument]>"
.Linfo_string75:
	.asciz	"args"
.Linfo_string76:
	.asciz	"value"
.Linfo_string77:
	.asciz	"{extern#0}"
.Linfo_string78:
	.asciz	"Opaque"
.Linfo_string79:
	.asciz	"&core::fmt::{extern#0}::Opaque"
.Linfo_string80:
	.asciz	"formatter"
.Linfo_string81:
	.asciz	"result"
.Linfo_string82:
	.asciz	"Ok"
.Linfo_string83:
	.asciz	"Error"
.Linfo_string84:
	.asciz	"E"
.Linfo_string85:
	.asciz	"Err"
.Linfo_string86:
	.asciz	"Result<(), core::fmt::Error>"
.Linfo_string87:
	.asciz	"Option<usize>"
.Linfo_string88:
	.asciz	"buf"
.Linfo_string89:
	.asciz	"pointer"
.Linfo_string90:
	.asciz	"dyn core::fmt::Write"
.Linfo_string91:
	.asciz	"vtable"
.Linfo_string92:
	.asciz	"__ARRAY_SIZE_TYPE__"
.Linfo_string93:
	.asciz	"&[usize; 3]"
.Linfo_string94:
	.asciz	"&mut dyn core::fmt::Write"
.Linfo_string95:
	.asciz	"Formatter"
.Linfo_string96:
	.asciz	"&mut core::fmt::Formatter"
.Linfo_string97:
	.asciz	"fn(&core::fmt::{extern#0}::Opaque, &mut core::fmt::Formatter) -> core::result::Result<(), core::fmt::Error>"
.Linfo_string98:
	.asciz	"ArgumentV1"
.Linfo_string99:
	.asciz	"&[core::fmt::ArgumentV1]"
.Linfo_string100:
	.asciz	"Arguments"
.Linfo_string101:
	.asciz	"core::fmt::Arguments::new_v1::hee4b73e401ea68f3"
.Linfo_string102:
	.asciz	"new_v1"
.Linfo_string103:
	.asciz	"F"
.Linfo_string104:
	.asciz	"std::sys_common::backtrace::__rust_begin_short_backtrace::h22b72b8c2013c45c"
.Linfo_string105:
	.asciz	"__rust_begin_short_backtrace<fn(), ()>"
.Linfo_string106:
	.asciz	"std::rt::lang_start::hec7bce37f31bbd41"
.Linfo_string107:
	.asciz	"lang_start<()>"
.Linfo_string108:
	.asciz	"isize"
.Linfo_string109:
	.asciz	"core::ops::function::FnOnce::call_once{{vtable.shim}}::hd0944ab9ee7fa202"
.Linfo_string110:
	.asciz	"core::ptr::drop_in_place<std::rt::lang_start<()>::{{closure}}>::h1d89ef1bc4b12bd0"
.Linfo_string111:
	.asciz	"drop_in_place<std::rt::lang_start::{closure_env#0}<()>>"
.Linfo_string112:
	.asciz	"main::main::h8a621b93f5f3e9cd"
.Linfo_string113:
	.asciz	"f"
.Linfo_string114:
	.asciz	"argc"
.Linfo_string115:
	.asciz	"argv"
.Linfo_string116:
	.asciz	"*const u8"
.Linfo_string117:
	.asciz	"*const *const u8"
.Linfo_string118:
	.asciz	"sigpipe"
.Linfo_string119:
	.asciz	"*mut std::rt::lang_start::{closure_env#0}<()>"
.Linfo_string120:
	.asciz	"x"
.Linfo_string121:
	.asciz	"Inch"
.Linfo_string122:
	.asciz	"Unit"
.Linfo_string123:
	.asciz	"f64"
.Linfo_string124:
	.asciz	"__1"
.Linfo_string125:
	.asciz	"marker"
.Linfo_string126:
	.asciz	"PhantomData<main::Inch>"
.Linfo_string127:
	.asciz	"Length<main::Inch>"
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end0-.LpubNames_start0
.LpubNames_start0:
	.short	2
	.long	.Lcu_begin0
	.long	2183
	.long	373
	.asciz	"backtrace"
	.long	1626
	.asciz	"marker"
	.long	999
	.asciz	"function"
	.long	527
	.asciz	"core"
	.long	166
	.asciz	"std"
	.long	558
	.asciz	"Left"
	.long	176
	.asciz	"lang_start"
	.long	576
	.asciz	"Unknown"
	.long	994
	.asciz	"ops"
	.long	1252
	.asciz	"ptr"
	.long	1304
	.asciz	"option"
	.long	564
	.asciz	"Right"
	.long	1257
	.asciz	"drop_in_place<std::rt::lang_start::{closure_env#0}<()>>"
	.long	570
	.asciz	"Center"
	.long	899
	.asciz	"{extern#0}"
	.long	1980
	.asciz	"main"
	.long	537
	.asciz	"rt"
	.long	532
	.asciz	"fmt"
	.long	542
	.asciz	"v1"
	.long	368
	.asciz	"sys_common"
	.long	42
	.asciz	"<std::rt::lang_start::{closure_env#0}<()> as core::ops::function::Fn<()>>::{vtable}"
	.long	1103
	.asciz	"call_once<std::rt::lang_start::{closure_env#0}<()>, ()>"
	.long	1218
	.asciz	"black_box<()>"
	.long	826
	.asciz	"new_v1"
	.long	1213
	.asciz	"hint"
	.long	229
	.asciz	"{closure#0}<()>"
	.long	1004
	.asciz	"FnOnce"
	.long	378
	.asciz	"__rust_begin_short_backtrace<fn(), ()>"
	.long	268
	.asciz	"lang_start<()>"
	.long	1009
	.asciz	"call_once<fn(), ()>"
	.long	1497
	.asciz	"result"
	.long	0
.LpubNames_end0:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end0-.LpubTypes_start0
.LpubTypes_start0:
	.short	2
	.long	.Lcu_begin0
	.long	2183
	.long	1802
	.asciz	"&[core::fmt::ArgumentV1]"
	.long	2119
	.asciz	"Inch"
	.long	2129
	.asciz	"isize"
	.long	1883
	.asciz	"&mut core::fmt::Formatter"
	.long	1854
	.asciz	"fn(&core::fmt::{extern#0}::Opaque, &mut core::fmt::Formatter) -> core::result::Result<(), core::fmt::Error>"
	.long	904
	.asciz	"Opaque"
	.long	1650
	.asciz	"u8"
	.long	2136
	.asciz	"*const *const u8"
	.long	159
	.asciz	"usize"
	.long	152
	.asciz	"()"
	.long	2175
	.asciz	"f64"
	.long	613
	.asciz	"FormatSpec"
	.long	919
	.asciz	"Formatter"
	.long	2162
	.asciz	"*mut std::rt::lang_start::{closure_env#0}<()>"
	.long	2080
	.asciz	"Length<main::Inch>"
	.long	1942
	.asciz	"&[usize; 3]"
	.long	1664
	.asciz	"&[&str]"
	.long	1788
	.asciz	"char"
	.long	547
	.asciz	"Alignment"
	.long	1742
	.asciz	"u64"
	.long	1309
	.asciz	"Option<&[core::fmt::rt::v1::Argument]>"
	.long	139
	.asciz	"*const ()"
	.long	583
	.asciz	"Argument"
	.long	1402
	.asciz	"Option<usize>"
	.long	513
	.asciz	"fn()"
	.long	1631
	.asciz	"PhantomData<main::Inch>"
	.long	2149
	.asciz	"*const u8"
	.long	676
	.asciz	"Count"
	.long	869
	.asciz	"ArgumentV1"
	.long	912
	.asciz	"Error"
	.long	61
	.asciz	"<std::rt::lang_start::{closure_env#0}<()> as core::ops::function::Fn<()>>::{vtable_type}"
	.long	1896
	.asciz	"&mut dyn core::fmt::Write"
	.long	1657
	.asciz	"i32"
	.long	1749
	.asciz	"&[core::fmt::rt::v1::Argument]"
	.long	1935
	.asciz	"dyn core::fmt::Write"
	.long	786
	.asciz	"Arguments"
	.long	1502
	.asciz	"Result<(), core::fmt::Error>"
	.long	1795
	.asciz	"u32"
	.long	181
	.asciz	"{closure_env#0}<()>"
	.long	1841
	.asciz	"&core::fmt::{extern#0}::Opaque"
	.long	1703
	.asciz	"&str"
	.long	0
.LpubTypes_end0:
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
