#!/usr/bin/env python3
"""
Generate comprehensive A64 ASM tests for dynarmic LoongArch64 backend.
Phase 3: More instruction categories and edge cases.
"""

import json
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

def write_test(filename, config, code, description=""):
    """Write a test file with CONFIG and code."""
    with open(filename, 'w') as f:
        f.write("/* CONFIG\n")
        f.write(json.dumps(config, indent=2))
        f.write("\n*/\n")
        if description:
            f.write(f"// {description}\n")
        f.write("\n.text\n")
        f.write(".global _start\n")
        f.write("_start:\n")
        for line in code.strip().split('\n'):
            f.write(f"    {line.strip()}\n")


def gen_extend_tests():
    """Generate sign/zero extend instruction tests."""
    ext_dir = os.path.join(BASE_DIR, "extend_ops")
    os.makedirs(ext_dir, exist_ok=True)
    tests = []
    
    # SXTB - Sign Extend Byte
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFF80"}}
    asm = """mov w0, #0x80
sxtb x0, w0           // sign extend byte: 0x80 -> 0xFF...80
brk #0"""
    write_test(f"{ext_dir}/sxtb_basic.s", config, asm, "SXTB sign extend byte")
    tests.append("sxtb_basic.s")
    
    # SXTH - Sign Extend Halfword
    config = {"RegData": {"X0": "0xFFFFFFFFFFFF8000"}}
    asm = """mov w0, #0x8000
sxth x0, w0           // sign extend halfword: 0x8000 -> 0xFF...8000
brk #0"""
    write_test(f"{ext_dir}/sxth_basic.s", config, asm, "SXTH sign extend halfword")
    tests.append("sxth_basic.s")
    
    # SXTW - Sign Extend Word
    config = {"RegData": {"X0": "0xFFFFFFFF80000000"}}
    asm = """mov w0, #0x80000000
sxtw x0, w0           // sign extend word: 0x80000000 -> 0xFF...80000000
brk #0"""
    write_test(f"{ext_dir}/sxtw_basic.s", config, asm, "SXTW sign extend word")
    tests.append("sxtw_basic.s")
    
    # UXTB - Zero Extend Byte
    config = {"RegData": {"X0": "0x0000000000000080"}}
    asm = """mov w0, #0xFFFFFF80
uxtb x0, w0           // zero extend byte: 0x80 -> 0x80
brk #0"""
    write_test(f"{ext_dir}/uxtb_basic.s", config, asm, "UXTB zero extend byte")
    tests.append("uxtb_basic.s")
    
    # UXTH - Zero Extend Halfword
    config = {"RegData": {"X0": "0x0000000000008000"}}
    asm = """mov w0, #0xFFFF8000
uxth x0, w0           // zero extend halfword: 0x8000 -> 0x8000
brk #0"""
    write_test(f"{ext_dir}/uxth_basic.s", config, asm, "UXTH zero extend halfword")
    tests.append("uxth_basic.s")
    
    # UXTW - Zero Extend Word
    config = {"RegData": {"X0": "0x0000000080000000"}}
    asm = """mov x0, #-1
uxtw x0, w0           // zero extend word: 0x80000000 -> 0x80000000
brk #0"""
    write_test(f"{ext_dir}/uxtw_basic.s", config, asm, "UXTW zero extend word")
    tests.append("uxtw_basic.s")
    
    # SBFIZ - Signed Bit Field Insert Zero
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}}
    asm = """mov x0, #0
sbfiz x0, x0, #0, #64  // insert 64 zeros at bit 0
brk #0"""
    write_test(f"{ext_dir}/sbfiz_basic.s", config, asm, "SBFIZ basic")
    tests.append("sbfiz_basic.s")
    
    # UBFIZ - Unsigned Bit Field Insert Zero
    config = {"RegData": {"X0": "0x00000000000000FF"}}
    asm = """mov x0, #0xFF
ubfiz x0, x0, #0, #8   // insert 8 bits at bit 0
brk #0"""
    write_test(f"{ext_dir}/ubfiz_basic.s", config, asm, "UBFIZ basic")
    tests.append("ubfiz_basic.s")
    
    # SBFX - Signed Bit Field Extract
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}}
    asm = """mov x0, #-1
sbfx x0, x0, #0, #8    // extract 8 bits, sign extend
brk #0"""
    write_test(f"{ext_dir}/sbfx_basic.s", config, asm, "SBFX basic")
    tests.append("sbfx_basic.s")
    
    # UBFX - Unsigned Bit Field Extract
    config = {"RegData": {"X0": "0x00000000000000FF"}}
    asm = """mov x0, #-1
ubfx x0, x0, #0, #8    // extract 8 bits, zero extend
brk #0"""
    write_test(f"{ext_dir}/ubfx_basic.s", config, asm, "UBFX basic")
    tests.append("ubfx_basic.s")
    
    return tests


def gen_fp_convert_tests():
    """Generate floating-point conversion tests."""
    fpconv_dir = os.path.join(BASE_DIR, "fp_convert")
    os.makedirs(fpconv_dir, exist_ok=True)
    tests = []
    
    # SCVTF - Signed Integer to Float
    config = {"RegData": {"X0": "0x0000000041800000"}}  # 16.0 in float
    asm = """mov x0, #16
scvtf s0, x0          // convert 16 to float: 16.0 = 0x41800000
mov w0, v0.s[0]
brk #0"""
    write_test(f"{fpconv_dir}/scvtf_basic.s", config, asm, "SCVTF basic")
    tests.append("scvtf_basic.s")
    
    # SCVTF - Negative
    config = {"RegData": {"X0": "0x00000000C1800000"}}  # -16.0
    asm = """mov x0, #-16
scvtf s0, x0          // convert -16 to float
mov w0, v0.s[0]
brk #0"""
    write_test(f"{fpconv_dir}/scvtf_negative.s", config, asm, "SCVTF negative")
    tests.append("scvtf_negative.s")
    
    # UCVTF - Unsigned Integer to Float
    config = {"RegData": {"X0": "0x000000004F800000"}}  # very large float
    asm = """mov x0, #0xFFFFFFFF
ucvtf s0, x0          // convert 0xFFFFFFFF to float
mov w0, v0.s[0]
brk #0"""
    write_test(f"{fpconv_dir}/ucvtf_basic.s", config, asm, "UCVTF basic")
    tests.append("ucvtf_basic.s")
    
    # FCVTZS - Float to Signed Integer
    config = {"RegData": {"X0": "0x0000000000000010"}}
    asm = """mov w0, #0x41800000    // 16.0 in float
mov s0, w0
fcvtzs x0, s0         // convert 16.0 to int: 16
brk #0"""
    write_test(f"{fpconv_dir}/fcvtzs_basic.s", config, asm, "FCVTZS basic")
    tests.append("fcvtzs_basic.s")
    
    # FCVTZU - Float to Unsigned Integer
    config = {"RegData": {"X0": "0x00000000FFFFFFFF"}}
    asm = """mov w0, #0x4F800000    // large float ~4.29e9
mov s0, w0
fcvtzu x0, s0         // convert to unsigned int
brk #0"""
    write_test(f"{fpconv_dir}/fcvtzu_basic.s", config, asm, "FCVTZU basic")
    tests.append("fcvtzu_basic.s")
    
    # FCVTAS - Float to Signed Integer (round to nearest)
    config = {"RegData": {"X0": "0x0000000000000010"}}
    asm = """mov w0, #0x41800001    // 16.000001
mov s0, w0
fcvtas x0, s0         // round to nearest: 16
brk #0"""
    write_test(f"{fpconv_dir}/fcvtas_basic.s", config, asm, "FCVTAS round to nearest")
    tests.append("fcvtas_basic.s")
    
    # FCVTMS - Float to Signed Integer (round toward minus infinity)
    config = {"RegData": {"X0": "0x0000000000000010"}}
    asm = """mov w0, #0x41800001    // 16.000001
mov s0, w0
fcvtms x0, s0         // floor: 16
brk #0"""
    write_test(f"{fpconv_dir}/fcvtms_basic.s", config, asm, "FCVTMS floor")
    tests.append("fcvtms_basic.s")
    
    # FCVTPS - Float to Signed Integer (round toward plus infinity)
    config = {"RegData": {"X0": "0x0000000000000011"}}
    asm = """mov w0, #0x41800001    // 16.000001
mov s0, w0
fcvtps x0, s0         // ceil: 17
brk #0"""
    write_test(f"{fpconv_dir}/fcvtps_basic.s", config, asm, "FCVTPS ceil")
    tests.append("fcvtps_basic.s")
    
    # FCVT double to single
    config = {"RegData": {"X0": "0x0000000041800000"}}  # 16.0 single
    asm = """mov x0, #0x4030000000000000  // 16.0 double
mov d0, x0
fcvt s0, d0           // double to single
mov w0, v0.s[0]
brk #0"""
    write_test(f"{fpconv_dir}/fcvt_d_s.s", config, asm, "FCVT double to single")
    tests.append("fcvt_d_s.s")
    
    # FCVT single to double
    config = {"RegData": {"X0": "0x4030000000000000"}}  # 16.0 double
    asm = """mov w0, #0x41800000    // 16.0 single
mov s0, w0
fcvt d0, s0           // single to double
mov x0, v0.d[0]
brk #0"""
    write_test(f"{fpconv_dir}/fcvt_s_d.s", config, asm, "FCVT single to double")
    tests.append("fcvt_s_d.s")
    
    # FRINTN - Round to nearest (ties to even)
    config = {"RegData": {"X0": "0x0000000041800000"}}
    asm = """mov w0, #0x41800000    // 16.0
mov s0, w0
frintn s0, s0         // round to nearest
mov w0, v0.s[0]
brk #0"""
    write_test(f"{fpconv_dir}/frintn_basic.s", config, asm, "FRINTN round nearest")
    tests.append("frintn_basic.s")
    
    # FRINTZ - Round toward zero
    config = {"RegData": {"X0": "0x0000000041800000"}}
    asm = """mov w0, #0x41808000    // 16.5
mov s0, w0
frintz s0, s0         // truncate: 16.0
mov w0, v0.s[0]
brk #0"""
    write_test(f"{fpconv_dir}/frintz_basic.s", config, asm, "FRINTZ truncate")
    tests.append("frintz_basic.s")
    
    return tests


def gen_logical_boundary_tests():
    """Generate logical instruction boundary tests."""
    logic_dir = os.path.join(BASE_DIR, "logical_boundary")
    os.makedirs(logic_dir, exist_ok=True)
    tests = []
    
    # AND with all ones
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}}
    asm = """mov x0, #-1
mov x1, #-1
and x0, x0, x1        // -1 & -1 = -1
brk #0"""
    write_test(f"{logic_dir}/and_all_ones.s", config, asm, "AND all ones")
    tests.append("and_all_ones.s")
    
    # AND with all zeros
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x0, #-1
mov x1, #0
and x0, x0, x1        // -1 & 0 = 0
brk #0"""
    write_test(f"{logic_dir}/and_all_zeros.s", config, asm, "AND all zeros")
    tests.append("and_all_zeros.s")
    
    # ORR with all zeros
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}}
    asm = """mov x0, #-1
mov x1, #0
orr x0, x0, x1        // -1 | 0 = -1
brk #0"""
    write_test(f"{logic_dir}/orr_with_zero.s", config, asm, "ORR with zero")
    tests.append("orr_with_zero.s")
    
    # EOR self (should be 0)
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x0, #-1
eor x0, x0, x0        // -1 ^ -1 = 0
brk #0"""
    write_test(f"{logic_dir}/eor_self.s", config, asm, "EOR self")
    tests.append("eor_self.s")
    
    # ORN - OR NOT
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}}
    asm = """mov x0, #0
mov x1, #0
orn x0, x0, x1        // 0 | ~0 = -1
brk #0"""
    write_test(f"{logic_dir}/orn_basic.s", config, asm, "ORN basic")
    tests.append("orn_basic.s")
    
    # ANDS - AND and set flags
    config = {"RegData": {"X0": "0x0000000000000000"}, "NZCV": "0x00000006"}
    asm = """mov x0, #0x0F
mov x1, #0xF0
ands x0, x0, x1       // 0x0F & 0xF0 = 0, Z=1, C=1
mrs x0, nzcv
brk #0"""
    write_test(f"{logic_dir}/ands_zero.s", config, asm, "ANDS zero result")
    tests.append("ands_zero.s")
    
    # BICS - Bit Clear and set flags
    config = {"RegData": {"X0": "0x0000000000000000"}, "NZCV": "0x00000006"}
    asm = """mov x0, #0xFF
mov x1, #0xFF
bics x0, x0, x1       // 0xFF & ~0xFF = 0, Z=1
mrs x0, nzcv
brk #0"""
    write_test(f"{logic_dir}/bics_basic.s", config, asm, "BICS basic")
    tests.append("bics_basic.s")
    
    # MOVN - Move NOT
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFE"}}
    asm = """movn x0, #1            // ~1 = -2
brk #0"""
    write_test(f"{logic_dir}/movn_basic.s", config, asm, "MOVN basic")
    tests.append("movn_basic.s")
    
    # MVN - Move NOT (alias)
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFE"}}
    asm = """mov x0, #1
mvn x0, x0            // ~1 = -2
brk #0"""
    write_test(f"{logic_dir}/mvn_basic.s", config, asm, "MVN basic")
    tests.append("mvn_basic.s")
    
    return tests


def gen_neg_tests():
    """Generate negate instruction tests."""
    neg_dir = os.path.join(BASE_DIR, "neg_ops")
    os.makedirs(neg_dir, exist_ok=True)
    tests = []
    
    # NEG basic
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFF6"}}
    asm = """mov x0, #10
neg x0, x0            // -10
brk #0"""
    write_test(f"{neg_dir}/neg_basic.s", config, asm, "NEG basic")
    tests.append("neg_basic.s")
    
    # NEG zero
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x0, #0
neg x0, x0            // -0 = 0
brk #0"""
    write_test(f"{neg_dir}/neg_zero.s", config, asm, "NEG zero")
    tests.append("neg_zero.s")
    
    # NEGS and flags
    config = {"RegData": {"X0": "0x0000000000000001"}, "NZCV": "0x0000000A"}
    asm = """mov x0, #0x7FFFFFFFFFFFFFFF  // max positive
movk x0, #0x7FFF, lsl #48
negs x0, x0           // negate max positive -> overflow
cset x0, vs           // x0 = 1 if overflow
brk #0"""
    write_test(f"{neg_dir}/negs_overflow.s", config, asm, "NEGS overflow")
    tests.append("negs_overflow.s")
    
    # NGC - Negate with Carry
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}}
    asm = """mov x0, #0
msr nzcv, xzr         // clear flags (C=0)
ngc x0, x0            // 0 - 0 - !C = 0 - 0 - 1 = -1
brk #0"""
    write_test(f"{neg_dir}/ngc_basic.s", config, asm, "NGC basic")
    tests.append("ngc_basic.s")
    
    # NGCS - Negate with Carry and set flags
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}}
    asm = """mov x0, #0
msr nzcv, xzr         // clear flags
ngcs x0, x0           // 0 - 0 - 1 = -1, sets flags
brk #0"""
    write_test(f"{neg_dir}/ngcs_basic.s", config, asm, "NGCS basic")
    tests.append("ngcs_basic.s")
    
    return tests


def gen_reg_overlap_boundary():
    """Generate more register overlap boundary tests."""
    overlap_dir = os.path.join(BASE_DIR, "reg_overlap_boundary")
    os.makedirs(overlap_dir, exist_ok=True)
    tests = []
    
    # ADD with same dest and src
    config = {"RegData": {"X0": "0x0000000000000014"}}
    asm = """mov x0, #10
add x0, x0, x0        // 10 + 10 = 20
brk #0"""
    write_test(f"{overlap_dir}/add_self.s", config, asm, "ADD self")
    tests.append("add_self.s")
    
    # SUB with same dest and src
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x0, #10
sub x0, x0, x0        // 10 - 10 = 0
brk #0"""
    write_test(f"{overlap_dir}/sub_self.s", config, asm, "SUB self")
    tests.append("sub_self.s")
    
    # MUL with same operands
    config = {"RegData": {"X0": "0x0000000000000064"}}
    asm = """mov x0, #10
mul x0, x0, x0        // 10 * 10 = 100
brk #0"""
    write_test(f"{overlap_dir}/mul_self.s", config, asm, "MUL self")
    tests.append("mul_self.s")
    
    # AND with same operands
    config = {"RegData": {"X0": "0x00000000000000FF"}}
    asm = """mov x0, #0xFF
and x0, x0, x0        // 0xFF & 0xFF = 0xFF
brk #0"""
    write_test(f"{overlap_dir}/and_self.s", config, asm, "AND self")
    tests.append("and_self.s")
    
    # EOR with same operands
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x0, #0xFF
eor x0, x0, x0        // 0xFF ^ 0xFF = 0
brk #0"""
    write_test(f"{overlap_dir}/eor_self.s", config, asm, "EOR self")
    tests.append("eor_self.s")
    
    # ORR with same operands
    config = {"RegData": {"X0": "0x00000000000000FF"}}
    asm = """mov x0, #0xFF
orr x0, x0, x0        // 0xFF | 0xFF = 0xFF
brk #0"""
    write_test(f"{overlap_dir}/orr_self.s", config, asm, "ORR self")
    tests.append("orr_self.s")
    
    # ADD with shift self
    config = {"RegData": {"X0": "0x000000000000002A"}}
    asm = """mov x0, #10
add x0, x0, x0, lsl #1  // 10 + (10<<1) = 10 + 20 = 30 = 0x1E
// Wait, that's 30 = 0x1E
brk #0"""
    config = {"RegData": {"X0": "0x000000000000001E"}}
    write_test(f"{overlap_dir}/add_self_shift.s", config, asm, "ADD self with shift")
    tests.append("add_self_shift.s")
    
    # Chain of operations with same reg
    config = {"RegData": {"X0": "0x000000000000001E"}}
    asm = """mov x0, #1
add x0, x0, x0        // 2
add x0, x0, x0        // 4
add x0, x0, x0        // 8
add x0, x0, x0        // 16
add x0, x0, #14       // 30 = 0x1E
brk #0"""
    write_test(f"{overlap_dir}/chain_same_reg.s", config, asm, "Chain same reg")
    tests.append("chain_same_reg.s")
    
    # 32-bit operations
    config = {"RegData": {"X0": "0x0000000000000014"}}
    asm = """mov w0, #10
add w0, w0, w0        // 20 (32-bit)
brk #0"""
    write_test(f"{overlap_dir}/add_self_32.s", config, asm, "ADD self 32-bit")
    tests.append("add_self_32.s")
    
    return tests


def main():
    print("Generating Phase 3 comprehensive A64 ASM tests...")
    
    extend_tests = gen_extend_tests()
    print(f"Generated {len(extend_tests)} extend operation tests")
    
    fpconv_tests = gen_fp_convert_tests()
    print(f"Generated {len(fpconv_tests)} FP conversion tests")
    
    logical_tests = gen_logical_boundary_tests()
    print(f"Generated {len(logical_tests)} logical boundary tests")
    
    neg_tests = gen_neg_tests()
    print(f"Generated {len(neg_tests)} negate operation tests")
    
    overlap_tests = gen_reg_overlap_boundary()
    print(f"Generated {len(overlap_tests)} register overlap boundary tests")
    
    total = len(extend_tests) + len(fpconv_tests) + len(logical_tests) + len(neg_tests) + len(overlap_tests)
    print(f"\nTotal: {total} new tests generated")


if __name__ == "__main__":
    main()
