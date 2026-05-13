#!/usr/bin/env python3
"""
Generate comprehensive A64 ASM tests for dynarmic LoongArch64 backend.
Phase 5: CCMP, CRC32, more vector ops, and edge cases.
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


def gen_ccmp_tests():
    """Generate conditional compare tests."""
    ccmp_dir = os.path.join(BASE_DIR, "ccmp_boundary")
    os.makedirs(ccmp_dir, exist_ok=True)
    tests = []
    
    # CCMP - conditional compare, condition true
    config = {"RegData": {"X0": "0x0000000080000000"}}
    asm = """mov x0, #5
mov x1, #3
cmp x0, x1           // 5 vs 3, N=0, Z=0, C=1, V=0
ccmp x0, #10, #0, gt // if 5>3, compare x0 vs 10
mrs x0, nzcv         // 5 < 10, so N=1
brk #0"""
    write_test(f"{ccmp_dir}/ccmp_gt_true.s", config, asm, "CCMP condition true")
    tests.append("ccmp_gt_true.s")
    
    # CCMP - condition false
    config = {"RegData": {"X0": "0x0000000030000000"}}
    asm = """mov x0, #5
mov x1, #10
cmp x0, x1           // 5 vs 10, N=1, Z=0, C=0, V=0
ccmp x0, #3, #0, gt  // condition false, use nzcv=0
mrs x0, nzcv         // Should be NZCV from first CMP
brk #0"""
    write_test(f"{ccmp_dir}/ccmp_gt_false.s", config, asm, "CCMP condition false")
    tests.append("ccmp_gt_false.s")
    
    # CCMN - conditional compare negative
    config = {"RegData": {"X0": "0x0000000080000000"}}
    asm = """mov x0, #5
mov x1, #3
cmp x0, x1           // 5 vs 3
ccmn x0, #3, #0, gt  // if 5>3, compare x0 vs -3
mrs x0, nzcv
brk #0"""
    write_test(f"{ccmp_dir}/ccmn_basic.s", config, asm, "CCMN basic")
    tests.append("ccmn_basic.s")
    
    # CCMP with all flags set
    config = {"RegData": {"X0": "0x00000000F0000000"}}
    asm = """mov x0, #5
mov x1, #10
cmp x0, x1           // N=1
ccmp xzr, xzr, #15, ge  // condition false, use nzcv=15 (all flags)
mrs x0, nzcv
brk #0"""
    write_test(f"{ccmp_dir}/ccmp_nzcv_fallback.s", config, asm, "CCMP nzcv fallback")
    tests.append("ccmp_nzcv_fallback.s")
    
    return tests


def gen_crc32_tests():
    """Generate CRC32 instruction tests."""
    crc_dir = os.path.join(BASE_DIR, "crc32_ops")
    os.makedirs(crc_dir, exist_ok=True)
    tests = []
    
    # CRC32B
    config = {"RegData": {"X0": "0x00000000E8172620"}}
    asm = """mov x0, #0
mov x1, #'A'
crc32b w0, w0, w1
brk #0"""
    write_test(f"{crc_dir}/crc32b_basic.s", config, asm, "CRC32B basic")
    tests.append("crc32b_basic.s")
    
    # CRC32H
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x0, #0
mov x1, #0x4142
crc32h w0, w0, w1
brk #0"""
    write_test(f"{crc_dir}/crc32h_basic.s", config, asm, "CRC32H basic")
    tests.append("crc32h_basic.s")
    
    # CRC32W
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x0, #0
mov x1, #0x41424344
crc32w w0, w0, w1
brk #0"""
    write_test(f"{crc_dir}/crc32w_basic.s", config, asm, "CRC32W basic")
    tests.append("crc32w_basic.s")
    
    # CRC32X
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x0, #0
mov x1, #0x4142434445464748
movk x1, #0x4142, lsl #48
crc32x w0, w0, x1
brk #0"""
    write_test(f"{crc_dir}/crc32x_basic.s", config, asm, "CRC32X basic")
    tests.append("crc32x_basic.s")
    
    # CRC32CB (Castagnoli)
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x0, #0
mov x1, #'A'
crc32cb w0, w0, w1
brk #0"""
    write_test(f"{crc_dir}/crc32cb_basic.s", config, asm, "CRC32CB basic")
    tests.append("crc32cb_basic.s")
    
    return tests


def gen_vector_arith_tests():
    """Generate more vector arithmetic tests."""
    vec_dir = os.path.join(BASE_DIR, "vector_arith")
    os.makedirs(vec_dir, exist_ok=True)
    tests = []
    
    # Vector subtract
    config = {"RegData": {"X0": "0x0000000100000001"}}
    asm = """movi v0.4s, #3
movi v1.4s, #2
sub v2.4s, v0.4s, v1.4s
mov x0, v2.d[0]
brk #0"""
    write_test(f"{vec_dir}/vsub_basic.s", config, asm, "VSUB basic")
    tests.append("vsub_basic.s")
    
    # Vector multiply
    config = {"RegData": {"X0": "0x0000000600000006"}}
    asm = """movi v0.4s, #3
movi v1.4s, #2
mul v2.4s, v0.4s, v1.4s
mov x0, v2.d[0]
brk #0"""
    write_test(f"{vec_dir}/vmul_basic.s", config, asm, "VMUL basic")
    tests.append("vmul_basic.s")
    
    # Vector MLA (multiply-accumulate)
    config = {"RegData": {"X0": "0x0000000700000007"}}
    asm = """movi v0.4s, #1
movi v1.4s, #2
movi v2.4s, #3
mla v2.4s, v0.4s, v1.4s  // v2 += v0 * v1 = 3 + 1*2 = 5
mov x0, v2.d[0]
brk #0"""
    write_test(f"{vec_dir}/vmla_basic.s", config, asm, "VMLA basic")
    tests.append("vmla_basic.s")
    
    # Vector MLS (multiply-subtract)
    config = {"RegData": {"X0": "0x0000000100000001"}}
    asm = """movi v0.4s, #2
movi v1.4s, #2
movi v2.4s, #5
mls v2.4s, v0.4s, v1.4s  // v2 -= v0 * v1 = 5 - 2*2 = 1
mov x0, v2.d[0]
brk #0"""
    write_test(f"{vec_dir}/vmls_basic.s", config, asm, "VMLS basic")
    tests.append("vmls_basic.s")
    
    # Vector AND
    config = {"RegData": {"X0": "0x0000000100000001"}}
    asm = """movi v0.4s, #3
movi v1.4s, #1
and v2.16b, v0.16b, v1.16b
mov x0, v2.d[0]
brk #0"""
    write_test(f"{vec_dir}/vand_basic.s", config, asm, "VAND basic")
    tests.append("vand_basic.s")
    
    # Vector ORR
    config = {"RegData": {"X0": "0x0000000300000003"}}
    asm = """movi v0.4s, #1
movi v1.4s, #2
orr v2.16b, v0.16b, v1.16b
mov x0, v2.d[0]
brk #0"""
    write_test(f"{vec_dir}/vorr_basic.s", config, asm, "VORR basic")
    tests.append("vorr_basic.s")
    
    # Vector EOR
    config = {"RegData": {"X0": "0x0000000300000003"}}
    asm = """movi v0.4s, #1
movi v1.4s, #2
eor v2.16b, v0.16b, v1.16b
mov x0, v2.d[0]
brk #0"""
    write_test(f"{vec_dir}/veor_basic.s", config, asm, "VEOR basic")
    tests.append("veor_basic.s")
    
    # Vector BIC
    config = {"RegData": {"X0": "0x0000000200000002"}}
    asm = """movi v0.4s, #3
movi v1.4s, #1
bic v2.16b, v0.16b, v1.16b  // v0 & ~v1 = 3 & ~1 = 2
mov x0, v2.d[0]
brk #0"""
    write_test(f"{vec_dir}/vbic_basic.s", config, asm, "VBIC basic")
    tests.append("vbic_basic.s")
    
    # Vector maximum
    config = {"RegData": {"X0": "0x0000000300000003"}}
    asm = """movi v0.4s, #3
movi v1.4s, #2
smax v2.4s, v0.4s, v1.4s
mov x0, v2.d[0]
brk #0"""
    write_test(f"{vec_dir}/vsmax_basic.s", config, asm, "VSMAX basic")
    tests.append("vsmax_basic.s")
    
    # Vector minimum
    config = {"RegData": {"X0": "0x0000000200000002"}}
    asm = """movi v0.4s, #3
movi v1.4s, #2
smin v2.4s, v0.4s, v1.4s
mov x0, v2.d[0]
brk #0"""
    write_test(f"{vec_dir}/vsmin_basic.s", config, asm, "VSMIN basic")
    tests.append("vsmin_basic.s")
    
    return tests


def gen_fp_vector_tests():
    """Generate floating-point vector tests."""
    fpv_dir = os.path.join(BASE_DIR, "fp_vector")
    os.makedirs(fpv_dir, exist_ok=True)
    tests = []
    
    # FADD vector
    config = {"RegData": {"X0": "0x0000000100000001"}}
    asm = """movi v0.4s, #1
movi v1.4s, #0
fadd v2.4s, v0.4s, v1.4s
mov x0, v2.d[0]
brk #0"""
    write_test(f"{fpv_dir}/vfadd_zero.s", config, asm, "VFADD with zero")
    tests.append("vfadd_zero.s")
    
    # FSUB vector
    config = {"RegData": {"X0": "0x0000000100000001"}}
    asm = """movi v0.4s, #1
movi v1.4s, #0
fsub v2.4s, v0.4s, v1.4s
mov x0, v2.d[0]
brk #0"""
    write_test(f"{fpv_dir}/vfsub_zero.s", config, asm, "VFSUB with zero")
    tests.append("vfsub_zero.s")
    
    # FMAX vector
    config = {"RegData": {"X0": "0x0000000200000002"}}
    asm = """movi v0.4s, #1
movi v1.4s, #2
fmax v2.4s, v0.4s, v1.4s
mov x0, v2.d[0]
brk #0"""
    write_test(f"{fpv_dir}/vfmax_basic.s", config, asm, "VFMAX basic")
    tests.append("vfmax_basic.s")
    
    # FMIN vector
    config = {"RegData": {"X0": "0x0000000100000001"}}
    asm = """movi v0.4s, #1
movi v1.4s, #2
fmin v2.4s, v0.4s, v1.4s
mov x0, v2.d[0]
brk #0"""
    write_test(f"{fpv_dir}/vfmin_basic.s", config, asm, "VFMIN basic")
    tests.append("vfmin_basic.s")
    
    return tests


def gen_shift_more_tests():
    """Generate more shift instruction tests."""
    shift_dir = os.path.join(BASE_DIR, "shift_more")
    os.makedirs(shift_dir, exist_ok=True)
    tests = []
    
    # ASR (arithmetic shift right)
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}}
    asm = """mov x0, #-1
asr x0, x0, #1
brk #0"""
    write_test(f"{shift_dir}/asr_neg.s", config, asm, "ASR negative")
    tests.append("asr_neg.s")
    
    # LSL by 63
    config = {"RegData": {"X0": "0x8000000000000000"}}
    asm = """mov x0, #1
lsl x0, x0, #63
brk #0"""
    write_test(f"{shift_dir}/lsl_63.s", config, asm, "LSL by 63")
    tests.append("lsl_63.s")
    
    # LSR by 63
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #0x8000000000000000
movk x0, #0x8000, lsl #48
lsr x0, x0, #63
brk #0"""
    write_test(f"{shift_dir}/lsr_63.s", config, asm, "LSR by 63")
    tests.append("lsr_63.s")
    
    # ROR (rotate right)
    config = {"RegData": {"X0": "0x0000000100000000"}}
    asm = """mov x0, #1
ror x0, x0, #32
brk #0"""
    write_test(f"{shift_dir}/ror_32.s", config, asm, "ROR by 32")
    tests.append("ror_32.s")
    
    # Variable shifts
    config = {"RegData": {"X0": "0x0000000000000004"}}
    asm = """mov x0, #1
mov x1, #2
lsl x0, x0, x1       // 1 << 2 = 4
brk #0"""
    write_test(f"{shift_dir}/lsl_var.s", config, asm, "LSL variable")
    tests.append("lsl_var.s")
    
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #4
mov x1, #2
lsr x0, x0, x1       // 4 >> 2 = 1
brk #0"""
    write_test(f"{shift_dir}/lsr_var.s", config, asm, "LSR variable")
    tests.append("lsr_var.s")
    
    config = {"RegData": {"X0": "0x4000000000000000"}}
    asm = """mov x0, #1
mov x1, #2
ror x0, x0, x1       // rotate 1 right by 2
brk #0"""
    write_test(f"{shift_dir}/ror_var.s", config, asm, "ROR variable")
    tests.append("ror_var.s")
    
    return tests


def main():
    print("Generating Phase 5 comprehensive A64 ASM tests...")
    
    ccmp_tests = gen_ccmp_tests()
    print(f"Generated {len(ccmp_tests)} CCMP/CCMN tests")
    
    crc_tests = gen_crc32_tests()
    print(f"Generated {len(crc_tests)} CRC32 tests")
    
    vec_tests = gen_vector_arith_tests()
    print(f"Generated {len(vec_tests)} vector arithmetic tests")
    
    fpv_tests = gen_fp_vector_tests()
    print(f"Generated {len(fpv_tests)} FP vector tests")
    
    shift_tests = gen_shift_more_tests()
    print(f"Generated {len(shift_tests)} more shift tests")
    
    total = len(ccmp_tests) + len(crc_tests) + len(vec_tests) + len(fpv_tests) + len(shift_tests)
    print(f"\nTotal: {total} new tests generated")


if __name__ == "__main__":
    main()
