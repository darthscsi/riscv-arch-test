// Experimental RISC-V extensions header
// Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
// SPDX-License-Identifier: Apache-2.0
// Contains a macro for each instruction from an unratified RISC-V extension
// so tests can be compiled without requiring the experimental extensions to
// be implemented in the compiler


#ifndef RISCV_ARCH_TEST_EXPERIMENTAL_H
#define RISCV_ARCH_TEST_EXPERIMENTAL_H

#if defined(__ASSEMBLER__) && defined(ENABLE_EXPERIMENTAL_EXTENSIONS)

.macro beqi rs1, cimm, target
  .if \cimm == -1
    .insn b 0x63, 2, \rs1, x0, \target
  .else
    .insn b 0x63, 2, \rs1, x\cimm, \target
  .endif
.endm

.macro bnei rs1, cimm, target
  .if \cimm == -1
    .insn b 0x63, 3, \rs1, x0, \target
  .else
    .insn b 0x63, 3, \rs1, x\cimm, \target
  .endif
.endm

// Zvkgs: assemble from the instruction fields so tests build without assembler support.
.macro RVTEST_VREGNUM out, reg
  .irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    .ifc \reg, v\i
      \out = \i
    .endif
  .endr
.endm

.macro RVTEST_ZVKGS funct6, vd, vs2, vs1
  RVTEST_VREGNUM .Lzvkgs_vd, \vd
  RVTEST_VREGNUM .Lzvkgs_vs2, \vs2
  .insn 4, 0x77 | (.Lzvkgs_vd << 7) | (2 << 12) | (\vs1 << 15) | (.Lzvkgs_vs2 << 20) | (1 << 25) | (\funct6 << 26)
.endm

.macro vghsh.vs vd, vs2, vs1
  RVTEST_VREGNUM .Lzvkgs_vs1, \vs1
  RVTEST_ZVKGS 0x23, \vd, \vs2, .Lzvkgs_vs1
.endm

.macro vgmul.vs vd, vs2
  RVTEST_ZVKGS 0x29, \vd, \vs2, 17
.endm

#endif

#endif
