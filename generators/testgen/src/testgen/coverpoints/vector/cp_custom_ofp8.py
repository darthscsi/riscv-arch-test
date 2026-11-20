##################################
# cp_custom_ofp8.py
#
# SPDX-License-Identifier: Apache-2.0
##################################

"""Edge values for the Zvfofp8min conversions between OFP8 and BF16 or binary32."""

import struct

from testgen.coverpoints.registry import add_coverpoint_generator
from testgen.data.state import TestData, return_testcase_registers
from testgen.data.test_chunk import TestChunk
from testgen.formatters import format_single_testcase
from testgen.instructions.vector_params import generate_random_vector_params

# vtype.altfmt selects the OFP8 format when SEW=8.
OFP8_FORMATS = (("e4m3", False), ("e5m2", True))

FRM_MODES = (("rne", 0), ("rtz", 1), ("rdn", 2), ("rup", 3), ("rmm", 4))

# OFP8 values converted to BF16. The conversion is exact.
OFP8_EDGES = {
    "e4m3": {
        "pos0": 0x00,
        "neg0": 0x80,
        "min_subnorm": 0x01,
        "max_subnorm": 0x07,
        "min_norm": 0x08,
        "pos1": 0x38,
        "neg1": 0xB8,
        "onePulp": 0x39,
        "max_finite": 0x7E,
        "neg_max_finite": 0xFE,
        "NaN": 0x7F,  # E4M3 has a single NaN encoding per sign and no infinity
        "negNaN": 0xFF,
    },
    "e5m2": {
        "pos0": 0x00,
        "neg0": 0x80,
        "min_subnorm": 0x01,
        "max_subnorm": 0x03,
        "min_norm": 0x04,
        "pos1": 0x3C,
        "neg1": 0xBC,
        "onePulp": 0x3D,
        "max_finite": 0x7B,
        "neg_max_finite": 0xFB,
        "posinfinity": 0x7C,
        "neginfinity": 0xFC,
        "sNaN": 0x7D,
        "qNaN": 0x7E,
        "negNaN": 0xFF,
    },
}

# (fraction bits, largest finite value, spacing of the values at the largest exponent, smallest
# normal value) of the OFP8 formats.
_OFP8_PARAMS = {"e4m3": (3, 448.0, 32.0, 2.0**-6), "e5m2": (2, 57344.0, 8192.0, 2.0**-14)}


def _f32(value: float) -> int:
    """Encoding of a value that is exactly representable in binary32."""
    encoding = struct.unpack("<I", struct.pack("<f", value))[0]
    assert struct.unpack("<f", struct.pack("<I", encoding))[0] == value, f"{value} is not a binary32 value"
    return encoding


def ofp8_source_edges(fmt: str, source_bits: int) -> dict[str, int]:
    """
    Edge values of a BF16 (source_bits=16) or binary32 (source_bits=32) source that is
    converted to the OFP8 format fmt. Most of the edges are at the boundaries where the result
    of the conversion depends on the rounding mode or on saturation.
    """
    frac_bits, max_finite, ulp_of_max, min_norm = _OFP8_PARAMS[fmt]
    min_subnorm = min_norm / 2**frac_bits
    half_ulp_of_one = 2.0 ** -(frac_bits + 1)
    # A value this far below the smallest normal value rounds up to it with an unbounded exponent
    # range, so it does not underflow in the round-to-nearest modes (tininess is detected after rounding).
    tininess_tie = min_norm - min_subnorm / 4
    # BF16 is the upper half of a binary32 value, so the same values serve both sources.
    shift = 32 - source_bits
    lsb = 1 << shift

    edges = {
        "pos0": 0x00000000,
        "neg0": 0x80000000,
        "pos1": _f32(1.0),
        "neg1": _f32(-1.0),
        "posinfinity": 0x7F800000,
        "neginfinity": 0xFF800000,
        "canonicalQNaN": 0x7FC00000,
        "sNaN": 0x7F800000 | lsb,
        # Overflow: the result is infinite (E5M2), the canonical NaN (E4M3) or saturates
        "max_finite": _f32(max_finite),
        "neg_max_finite": _f32(-max_finite),
        "below_overflow_tie": _f32(max_finite + ulp_of_max / 2) - lsb,
        "overflow_tie": _f32(max_finite + ulp_of_max / 2),
        "neg_overflow_tie": _f32(-(max_finite + ulp_of_max / 2)),
        "above_overflow_tie": _f32(max_finite + ulp_of_max / 2) + lsb,
        "overflow": _f32(2 * max_finite),
        "neg_overflow": _f32(-2 * max_finite),
        "source_max": 0x7F7FFFFF & ~(lsb - 1),
        # Rounding of a normal result
        "onePhalfulp": _f32(1.0 + half_ulp_of_one),  # a tie that rounds down to even
        "onePulpPhalfulp": _f32(1.0 + 3 * half_ulp_of_one),  # a tie that rounds up to even
        "neg_onePhalfulpPlsb": _f32(-(1.0 + half_ulp_of_one)) + lsb,
        # Underflow
        "min_norm": _f32(min_norm),
        "tininess_tie": _f32(tininess_tie),
        "below_tininess_tie": _f32(tininess_tie) - lsb,
        "min_subnorm": _f32(min_subnorm),
        "half_min_subnorm": _f32(min_subnorm / 2),
        "above_half_min_subnorm": _f32(min_subnorm / 2) + lsb,
        "neg_above_half_min_subnorm": _f32(-min_subnorm / 2) + lsb,
        "source_min_subnorm": lsb,
    }
    return {name: value >> shift for name, value in edges.items()}


@add_coverpoint_generator("cp_custom_ofp8_edges")
def cp_custom_ofp8_edges(instr_name: str, instr_type: str, coverpoint: str, test_data: TestData) -> list[TestChunk]:
    """
    Convert edge values in both OFP8 formats.

    cp_custom_ofp8_edges_widen: OFP8 edges converted to BF16.
    cp_custom_ofp8_edges_bf16 and cp_custom_ofp8_edges_f32: BF16 or binary32 edges converted to
    OFP8, crossed with the rounding modes.
    """
    assert test_data.config.sew == 8, "The OFP8 formats are selected with SEW=8"
    source = coverpoint.removeprefix("cp_custom_ofp8_edges_")

    test_chunks = []
    for fmt, altfmt in OFP8_FORMATS:
        if source == "widen":
            cases = [(name, value, "rne", 0, f"{fmt}_{name}") for name, value in OFP8_EDGES[fmt].items()]
            source_bits = 8
        elif source in ("bf16", "f32"):
            source_bits = 16 if source == "bf16" else 32
            cases = [
                (name, value, frm_name, frm_val, f"{fmt}_{name}_{frm_name}")
                for name, value in ofp8_source_edges(fmt, source_bits).items()
                for frm_name, frm_val in FRM_MODES
            ]
        else:
            raise ValueError(f"Unknown cp_custom_ofp8_edges coverpoint variant: {coverpoint} for {instr_name}")

        for name, value, frm_name, frm_val, bin_name in cases:
            label = f"{coverpoint}_{fmt}_{name}"
            if label not in test_data.vector_labels:
                test_data.register_vector_data(label, source_bits, elements=[value])
            params = generate_random_vector_params(
                test_data, instr_name, instr_type, 1, vl=1, vs2_val_pointer=label, csr_frm_val=frm_val, altfmt=altfmt
            )
            desc = f"{coverpoint} ({fmt.upper()}, vs2 = {name}, frm = {frm_name})"
            tc = format_single_testcase(instr_name, instr_type, test_data, params, desc, bin_name, coverpoint)
            return_testcase_registers(test_data, params)
            test_chunks.append(tc)

    return test_chunks
