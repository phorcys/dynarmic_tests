#!/usr/bin/env python3
"""
Generate comprehensive A64 ASM tests for dynarmic LoongArch64 backend.
Phase 4: SIMD, crypto, system instructions, and more edge cases.
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


def gen_simd_boundary_tests():
    """Generate SIMD vector boundary tests."""
    simd_dir = os.path.join(BASE_DIR, "simd_boundary")
    os.makedirs(simd_dir, exist_ok=True)
    tests = []
    
    # Vector duplicate
    config = {"RegData": {"X0": "0x00000000000000FF"}}
    asm = """movi v0.16b, #0xFF
mov w0, v0.b[0]
brk #0"""
    write_test(f"{simd_dir}/movi_16b.s", config, asm, "MOVI 16 bytes")
    tests.append("movi_16b.s")
    
    # Vector insert
    config = {"RegData": {"X0": "0x0000000000000042"}}
    asm = """movi v0.16b, #0
mov w1, #0x42
ins v0.b[0], w1
mov w0, v0.b[0]
brk #0"""
    write_test(f"{simd_dir}/ins_b.s", config, asm, "INS byte")
    tests.append("ins_b.s")
    
    # Vector extract
    config = {"RegData": {"X0": "0x0000000000000003"}}
    asm = """movi v0.4s, #1
movi v1.4s, #2
add v2.4s, v0.4s, v1.4s
mov w0, v2.s[0]
brk #0"""
    write_test(f"{simd_dir}/vadd_result.s", config, asm, "VADD result")
    tests.append("vadd_result.s")
    
    # Vector bitwise select (BSL)
    config = {"RegData": {"X0": "0x00000000000000F0"}}
    asm = """movi v0.16b, #0xFF
movi v1.16b, #0x0F
movi v2.16b, #0xF0
bsl v0.16b, v1.16b, v2.16b
mov w0, v0.b[0]
brk #0"""
    write_test(f"{simd_dir}/bsl_basic.s", config, asm, "BSL bitwise select")
    tests.append("bsl_basic.s")
    
    # Vector reverse
    config = {"RegData": {"X0": "0x0000000000000002"}}
    asm = """movi v0.4s, #1
movi v1.4s, #2
rev64 v2.4s, v0.4s
mov w0, v2.s[0]
brk #0"""
    write_test(f"{simd_dir}/rev64_basic.s", config, asm, "REV64 vector")
    tests.append("rev64_basic.s")
    
    # Vector transpose
    config = {"RegData": {"X0": "0x0000000000000002"}}
    asm = """movi v0.4s, #1
movi v1.4s, #2
trn1 v2.4s, v0.4s, v1.4s
mov w0, v2.s[1]
brk #0"""
    write_test(f"{simd_dir}/trn1_basic.s", config, asm, "TRN1 transpose")
    tests.append("trn1_basic.s")
    
    # Vector zip
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """movi v0.4s, #1
movi v1.4s, #2
zip1 v2.4s, v0.4s, v1.4s
mov w0, v2.s[0]
brk #0"""
    write_test(f"{simd_dir}/zip1_basic.s", config, asm, "ZIP1 interleave")
    tests.append("zip1_basic.s")
    
    # Vector unzip
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """movi v0.4s, #1
movi v1.4s, #2
zip1 v2.4s, v0.4s, v1.4s
uzp1 v3.4s, v2.4s, v2.4s
mov w0, v3.s[0]
brk #0"""
    write_test(f"{simd_dir}/uzp1_basic.s", config, asm, "UZP1 deinterleave")
    tests.append("uzp1_basic.s")
    
    # Vector compare equal
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}}
    asm = """movi v0.4s, #1
movi v1.4s, #1
cmeq v2.4s, v0.4s, v1.4s
mov x0, v2.d[0]
brk #0"""
    write_test(f"{simd_dir}/cmeq_basic.s", config, asm, "CMEQ vector compare")
    tests.append("cmeq_basic.s")
    
    # Vector compare greater
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """movi v0.4s, #1
movi v1.4s, #2
cmgt v2.4s, v0.4s, v1.4s
mov x0, v2.d[0]
brk #0"""
    write_test(f"{simd_dir}/cmgt_basic.s", config, asm, "CMGT vector compare")
    tests.append("cmgt_basic.s")
    
    return tests


def gen_system_tests():
    """Generate system instruction tests."""
    sys_dir = os.path.join(BASE_DIR, "system_ops")
    os.makedirs(sys_dir, exist_ok=True)
    tests = []
    
    # NOP
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #1
nop
brk #0"""
    write_test(f"{sys_dir}/nop_basic.s", config, asm, "NOP basic")
    tests.append("nop_basic.s")
    
    # YIELD
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #1
yield
brk #0"""
    write_test(f"{sys_dir}/yield_basic.s", config, asm, "YIELD basic")
    tests.append("yield_basic.s")
    
    # WFE (Wait For Event)
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #1
wfe
brk #0"""
    write_test(f"{sys_dir}/wfe_basic.s", config, asm, "WFE basic")
    tests.append("wfe_basic.s")
    
    # WFI (Wait For Interrupt)
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #1
wfi
brk #0"""
    write_test(f"{sys_dir}/wfi_basic.s", config, asm, "WFI basic")
    tests.append("wfi_basic.s")
    
    # SEV (Send Event)
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #1
sev
brk #0"""
    write_test(f"{sys_dir}/sev_basic.s", config, asm, "SEV basic")
    tests.append("sev_basic.s")
    
    # SEVL (Send Event Local)
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #1
sevl
brk #0"""
    write_test(f"{sys_dir}/sevl_basic.s", config, asm, "SEVL basic")
    tests.append("sevl_basic.s")
    
    # DMB (Data Memory Barrier)
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #1
dmb sy
brk #0"""
    write_test(f"{sys_dir}/dmb_basic.s", config, asm, "DMB basic")
    tests.append("dmb_basic.s")
    
    # DSB (Data Synchronization Barrier)
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #1
dsb sy
brk #0"""
    write_test(f"{sys_dir}/dsb_basic.s", config, asm, "DSB basic")
    tests.append("dsb_basic.s")
    
    # ISB (Instruction Synchronization Barrier)
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #1
isb
brk #0"""
    write_test(f"{sys_dir}/isb_basic.s", config, asm, "ISB basic")
    tests.append("isb_basic.s")
    
    # CLREX (Clear Exclusive)
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #1
clrex
brk #0"""
    write_test(f"{sys_dir}/clrex_basic.s", config, asm, "CLREX basic")
    tests.append("clrex_basic.s")
    
    return tests


def gen_carry_tests():
    """Generate carry flag boundary tests."""
    carry_dir = os.path.join(BASE_DIR, "carry_boundary")
    os.makedirs(carry_dir, exist_ok=True)
    tests = []
    
    # ADC with carry in
    config = {"RegData": {"X0": "0x0000000000000003"}}
    asm = """mov x0, #1
mov x1, #1
msr nzcv, xzr         // clear flags (C=0)
adc x0, x0, x1        // 1 + 1 + 0 = 2
add x0, x0, #1        // 3
brk #0"""
    write_test(f"{carry_dir}/adc_no_carry.s", config, asm, "ADC no carry in")
    tests.append("adc_no_carry.s")
    
    # ADC with carry in = 1
    config = {"RegData": {"X0": "0x0000000000000003"}}
    asm = """mov x0, #1
mov x1, #1
cmp xzr, xzr          // set C=1 (0 >= 0)
adc x0, x0, x1        // 1 + 1 + 1 = 3
brk #0"""
    write_test(f"{carry_dir}/adc_with_carry.s", config, asm, "ADC with carry in")
    tests.append("adc_with_carry.s")
    
    # SBC with carry
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #5
mov x1, #3
cmp xzr, xzr          // set C=1
sbc x0, x0, x1        // 5 - 3 - 0 = 2? No, SBC is x0 - x1 - !C
// With C=1: 5 - 3 - 0 = 2
// But we want to test it properly
brk #0"""
    config = {"RegData": {"X0": "0x0000000000000002"}}
    write_test(f"{carry_dir}/sbc_basic.s", config, asm, "SBC basic")
    tests.append("sbc_basic.s")
    
    # ADCS set flags
    config = {"RegData": {"X0": "0x0000000040000000"}}
    asm = """mov x0, #1
mov x1, #0xFFFFFFFFFFFFFFFF
cmp xzr, xzr          // C=1
adcs x0, x0, x1       // 1 + (-1) + 1 = 1, sets flags
mrs x0, nzcv          // NZCV
brk #0"""
    write_test(f"{carry_dir}/adcs_flags.s", config, asm, "ADCS flags")
    tests.append("adcs_flags.s")
    
    # SBCS set flags
    config = {"RegData": {"X0": "0x0000000080000000"}}
    asm = """mov x0, #0
mov x1, #1
msr nzcv, xzr         // C=0
sbcs x0, x0, x1       // 0 - 1 - 1 = -2, N=1
mrs x0, nzcv
brk #0"""
    write_test(f"{carry_dir}/sbcs_flags.s", config, asm, "SBCS flags")
    tests.append("sbcs_flags.s")
    
    return tests


def gen_bit_count_tests():
    """Generate bit counting instruction tests."""
    bitcnt_dir = os.path.join(BASE_DIR, "bit_count")
    os.makedirs(bitcnt_dir, exist_ok=True)
    tests = []
    
    # CLZ - count leading zeros
    config = {"RegData": {"X0": "0x000000000000003F"}}
    asm = """mov x0, #1
clz x0, x0            // 63 leading zeros
brk #0"""
    write_test(f"{bitcnt_dir}/clz_one.s", config, asm, "CLZ one bit")
    tests.append("clz_one.s")
    
    # CLZ all zeros
    config = {"RegData": {"X0": "0x0000000000000040"}}
    asm = """mov x0, #0
clz x0, x0            // 64 leading zeros
brk #0"""
    write_test(f"{bitcnt_dir}/clz_zero.s", config, asm, "CLZ zero")
    tests.append("clz_zero.s")
    
    # CLZ high bit
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x0, #0x8000000000000000
movk x0, #0x8000, lsl #48
clz x0, x0            // 0 leading zeros
brk #0"""
    write_test(f"{bitcnt_dir}/clz_high.s", config, asm, "CLZ high bit set")
    tests.append("clz_high.s")
    
    # CLS - count leading sign bits
    config = {"RegData": {"X0": "0x000000000000003E"}}
    asm = """mov x0, #-2
cls x0, x0            // 62 sign bits match (all 1s except MSB pair)
brk #0"""
    write_test(f"{bitcnt_dir}/cls_neg.s", config, asm, "CLS negative")
    tests.append("cls_neg.s")
    
    # RBIT - reverse bits
    config = {"RegData": {"X0": "0x8000000000000000"}}
    asm = """mov x0, #1
rbit x0, x0           // reverse: 0x8000000000000000
brk #0"""
    write_test(f"{bitcnt_dir}/rbit_one.s", config, asm, "RBIT single bit")
    tests.append("rbit_one.s")
    
    # CNT - count set bits per byte
    config = {"RegData": {"X0": "0x0808080808080808"}}
    asm = """movi v0.16b, #0xFF
cnt v0.16b, v0.16b    // each byte: 8 set bits
mov x0, v0.d[0]
brk #0"""
    write_test(f"{bitcnt_dir}/cnt_bytes.s", config, asm, "CNT count bits per byte")
    tests.append("cnt_bytes.s")
    
    return tests


def gen_saturation_tests():
    """Generate saturation arithmetic tests."""
    sat_dir = os.path.join(BASE_DIR, "saturation")
    os.makedirs(sat_dir, exist_ok=True)
    tests = []
    
    # SQADD - saturating add signed
    config = {"RegData": {"X0": "0x7FFFFFFFFFFFFFFF"}}
    asm = """mov x0, #0x7FFFFFFFFFFFFFFF
movk x0, #0x7FFF, lsl #48
mov x1, #0
sqadd x0, x0, x1      // max + 0 = max (no saturation)
brk #0"""
    write_test(f"{sat_dir}/sqadd_max.s", config, asm, "SQADD max no sat")
    tests.append("sqadd_max.s")
    
    # UQADD - saturating add unsigned
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}}
    asm = """mov x0, #-1
mov x1, #0
uqadd x0, x0, x1      // max + 0 = max
brk #0"""
    write_test(f"{sat_dir}/uqadd_max.s", config, asm, "UQADD max no sat")
    tests.append("uqadd_max.s")
    
    # SQSUB - saturating sub signed
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #1
mov x1, #0
sqsub x0, x0, x1      // 1 - 0 = 1
brk #0"""
    write_test(f"{sat_dir}/sqsub_basic.s", config, asm, "SQSUB basic")
    tests.append("sqsub_basic.s")
    
    # UQSUB - saturating sub unsigned
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x0, #0
mov x1, #1
uqsub x0, x0, x1      // 0 - 1 = 0 (saturated)
brk #0"""
    write_test(f"{sat_dir}/uqsub_sat.s", config, asm, "UQSUB saturate to 0")
    tests.append("uqsub_sat.s")
    
    # SUQADD - signed saturating add unsigned
    config = {"RegData": {"X0": "0x0000000000000005"}}
    asm = """mov x0, #3
mov x1, #2
suqadd x0, x0, x1     // 3 + 2 = 5
brk #0"""
    write_test(f"{sat_dir}/suqadd_basic.s", config, asm, "SUQADD basic")
    tests.append("suqadd_basic.s")
    
    # USQADD - unsigned saturating add signed
    config = {"RegData": {"X0": "0x0000000000000005"}}
    asm = """mov x0, #3
mov x1, #2
usqadd x0, x0, x1     // 3 + 2 = 5
brk #0"""
    write_test(f"{sat_dir}/usqadd_basic.s", config, asm, "USQADD basic")
    tests.append("usqadd_basic.s")
    
    return tests


def main():
    print("Generating Phase 4 comprehensive A64 ASM tests...")
    
    simd_tests = gen_simd_boundary_tests()
    print(f"Generated {len(simd_tests)} SIMD boundary tests")
    
    system_tests = gen_system_tests()
    print(f"Generated {len(system_tests)} system instruction tests")
    
    carry_tests = gen_carry_tests()
    print(f"Generated {len(carry_tests)} carry boundary tests")
    
    bitcnt_tests = gen_bit_count_tests()
    print(f"Generated {len(bitcnt_tests)} bit count tests")
    
    sat_tests = gen_saturation_tests()
    print(f"Generated {len(sat_tests)} saturation tests")
    
    total = len(simd_tests) + len(system_tests) + len(carry_tests) + len(bitcnt_tests) + len(sat_tests)
    print(f"\nTotal: {total} new tests generated")


if __name__ == "__main__":
    main()
