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

// Zvfofp8min. The instructions are OPFVV VFUNARY0 encodings selected by the vs1 field.
// RVTEST_VREG_v<n> maps a vector register name to its number.
.irp n, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
  .equ RVTEST_VREG_v\n, \n
.endr

.macro RVTEST_VFUNARY0 vs1, vd, vs2, vm
  .ifb \vm
    .insn 4, 0x4A001057 | (RVTEST_VREG_\vs2 << 20) | (\vs1 << 15) | (RVTEST_VREG_\vd << 7)
  .else
    .insn 4, 0x48001057 | (RVTEST_VREG_\vs2 << 20) | (\vs1 << 15) | (RVTEST_VREG_\vd << 7)
  .endif
.endm

// With SEW=8 these two Zvfbfmin encodings convert between OFP8 and BF16. Zvfofp8min does not
// require Zvfbfmin, so the assembler may not accept the mnemonics.
.macro vfwcvtbf16.f.f.v vd, vs2, vm
  RVTEST_VFUNARY0 13, \vd, \vs2, \vm
.endm

.macro vfncvtbf16.f.f.w vd, vs2, vm
  RVTEST_VFUNARY0 29, \vd, \vs2, \vm
.endm

.macro vfncvt.f.f.q vd, vs2, vm
  RVTEST_VFUNARY0 25, \vd, \vs2, \vm
.endm

.macro vfncvt.sat.f.f.q vd, vs2, vm
  RVTEST_VFUNARY0 27, \vd, \vs2, \vm
.endm

.macro vfncvtbf16.sat.f.f.w vd, vs2, vm
  RVTEST_VFUNARY0 31, \vd, \vs2, \vm
.endm

#endif

#endif
