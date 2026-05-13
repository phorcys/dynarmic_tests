#!/usr/bin/env python3
"""
Generate comprehensive A64 ASM tests for dynarmic LoongArch64 backend.
Phase 6: Division, conditional select, FP special values, branch edge cases.
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


def gen_div_boundary_tests():
    """Generate division boundary tests."""
    div_dir = os.path.join(BASE_DIR, "div_boundary")
    os.makedirs(div_dir, exist_ok=True)
    tests = []
    
    # SDIV basic
    config = {"RegData": {"X0": "0x0000000000000002"}}
    asm = """mov x0, #10
mov x1, #5
sdiv x0, x0, x1
brk #0"""
    write_test(f"{div_dir}/sdiv_basic.s", config, asm, "SDIV basic")
    tests.append("sdiv_basic.s")
    
    # SDIV negative
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFE"}}
    asm = """mov x0, #-10
mov x1, #5
sdiv x0, x0, x1
brk #0"""
    write_test(f"{div_dir}/sdiv_neg.s", config, asm, "SDIV negative")
    tests.append("sdiv_neg.s")
    
    # UDIV basic
    config = {"RegData": {"X0": "0x0000000000000002"}}
    asm = """mov x0, #10
mov x1, #5
udiv x0, x0, x1
brk #0"""
    write_test(f"{div_dir}/udiv_basic.s", config, asm, "UDIV basic")
    tests.append("udiv_basic.s")
    
    # Division by zero returns 0
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x0, #10
mov x1, #0
udiv x0, x0, x1
brk #0"""
    write_test(f"{div_dir}/udiv_zero.s", config, asm, "UDIV by zero")
    tests.append("udiv_zero.s")
    
    # SDIV by zero
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x0, #10
mov x1, #0
sdiv x0, x0, x1
brk #0"""
    write_test(f"{div_dir}/sdiv_zero.s", config, asm, "SDIV by zero")
    tests.append("sdiv_zero.s")
    
    # Division of INT_MIN by -1 (overflow case)
    config = {"RegData": {"X0": "0x8000000000000000"}}
    asm = """mov x0, #0x8000000000000000
movk x0, #0x8000, lsl #48
mov x1, #-1
sdiv x0, x0, x1
brk #0"""
    write_test(f"{div_dir}/sdiv_overflow.s", config, asm, "SDIV overflow")
    tests.append("sdiv_overflow.s")
    
    return tests


def gen_csel_boundary_tests():
    """Generate conditional select boundary tests."""
    csel_dir = os.path.join(BASE_DIR, "csel_boundary")
    os.makedirs(csel_dir, exist_ok=True)
    tests = []
    
    # CSEL - select based on condition
    config = {"RegData": {"X0": "0x000000000000000A"}}
    asm = """mov x0, #10
mov x1, #20
cmp x0, x1
csel x2, x0, x1, lt  // if 10 < 20, select x0
mov x0, x2
brk #0"""
    write_test(f"{csel_dir}/csel_lt_true.s", config, asm, "CSEL lt true")
    tests.append("csel_lt_true.s")
    
    # CSEL condition false
    config = {"RegData": {"X0": "0x0000000000000014"}}
    asm = """mov x0, #10
mov x1, #20
cmp x0, x1
csel x2, x0, x1, gt  // if 10 > 20 (false), select x1
mov x0, x2
brk #0"""
    write_test(f"{csel_dir}/csel_gt_false.s", config, asm, "CSEL gt false")
    tests.append("csel_gt_false.s")
    
    # CSINC - conditional select increment
    config = {"RegData": {"X0": "0x000000000000000A"}}
    asm = """mov x0, #10
mov x1, #20
cmp x0, x0          // equal, Z=1
csinc x2, x0, x1, eq  // if eq, select x0; else x1+1
mov x0, x2
brk #0"""
    write_test(f"{csel_dir}/csinc_eq.s", config, asm, "CSINC eq")
    tests.append("csinc_eq.s")
    
    # CSINC condition false
    config = {"RegData": {"X0": "0x0000000000000015"}}
    asm = """mov x0, #10
mov x1, #20
cmp x0, x1          // 10 != 20, ne
csinc x2, x0, x1, eq  // if eq (false), select x1+1
mov x0, x2
brk #0"""
    write_test(f"{csel_dir}/csinc_ne.s", config, asm, "CSINC ne")
    tests.append("csinc_ne.s")
    
    # CSINV - conditional select invert
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFF5"}}
    asm = """mov x0, #10
mov x1, #20
cmp x0, x1          // 10 < 20
csinv x2, x0, x1, ge  // if ge (false), select ~x1
mov x0, x2
brk #0"""
    write_test(f"{csel_dir}/csinv_ge.s", config, asm, "CSINV ge false")
    tests.append("csinv_ge.s")
    
    # CSNEG - conditional select negate
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFEC"}}
    asm = """mov x0, #10
mov x1, #20
cmp x0, x1          // 10 < 20
csneg x2, x0, x1, ge  // if ge (false), select -x1
mov x0, x2
brk #0"""
    write_test(f"{csel_dir}/csneg_ge.s", config, asm, "CSNEG ge false")
    tests.append("csneg_ge.s")
    
    # CSET - conditional set
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #5
cmp x0, #3
cset x0, gt         // if 5 > 3, set 1
brk #0"""
    write_test(f"{csel_dir}/cset_true.s", config, asm, "CSET true")
    tests.append("cset_true.s")
    
    # CSET false
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x0, #5
cmp x0, #10
cset x0, gt         // if 5 > 10 (false), set 0
brk #0"""
    write_test(f"{csel_dir}/cset_false.s", config, asm, "CSET false")
    tests.append("cset_false.s")
    
    # CINC - conditional increment
    config = {"RegData": {"X0": "0x0000000000000006"}}
    asm = """mov x0, #5
cmp x0, #3
cinc x0, x0, gt     // if 5 > 3, x0 = x0 + 1
brk #0"""
    write_test(f"{csel_dir}/cinc_true.s", config, asm, "CINC true")
    tests.append("cinc_true.s")
    
    # CINV - conditional invert
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFA"}}
    asm = """mov x0, #5
cmp x0, #3
cinv x0, x0, gt     // if 5 > 3, x0 = ~x0
brk #0"""
    write_test(f"{csel_dir}/cinv_true.s", config, asm, "CINV true")
    tests.append("cinv_true.s")
    
    return tests


def gen_fp_special_tests():
    """Generate floating-point special value tests."""
    fp_dir = os.path.join(BASE_DIR, "fp_special")
    os.makedirs(fp_dir, exist_ok=True)
    tests = []
    
    # FMUL by 1.0
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """fmov s0, #1.0
fmov s1, #2.0
fmul s2, s0, s1
fmov w0, s2
brk #0"""
    write_test(f"{fp_dir}/fmul_basic.s", config, asm, "FMUL basic")
    tests.append("fmul_basic.s")
    
    # FDIV basic
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """fmov s0, #10.0
fmov s1, #2.0
fdiv s2, s0, s1
fmov w0, s2
brk #0"""
    write_test(f"{fp_dir}/fdiv_basic.s", config, asm, "FDIV basic")
    tests.append("fdiv_basic.s")
    
    # FSQRT basic
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """fmov s0, #4.0
fsqrt s1, s0
fmov w0, s1
brk #0"""
    write_test(f"{fp_dir}/fsqrt_basic.s", config, asm, "FSQRT basic")
    tests.append("fsqrt_basic.s")
    
    # FABS
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """fmov s0, #-2.0
fabs s1, s0
fmov w0, s1
brk #0"""
    write_test(f"{fp_dir}/fabs_basic.s", config, asm, "FABS basic")
    tests.append("fabs_basic.s")
    
    # FNEG
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """fmov s0, #2.0
fneg s1, s0
fmov w0, s1
brk #0"""
    write_test(f"{fp_dir}/fneg_basic.s", config, asm, "FNEG basic")
    tests.append("fneg_basic.s")
    
    # FNMUL
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """fmov s0, #2.0
fmov s1, #3.0
fnmul s2, s0, s1    // -(2.0 * 3.0) = -6.0
fmov w0, s2
brk #0"""
    write_test(f"{fp_dir}/fnmul_basic.s", config, asm, "FNMUL basic")
    tests.append("fnmul_basic.s")
    
    # FMADD
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """fmov s0, #2.0
fmov s1, #3.0
fmov s2, #4.0
fmadd s3, s0, s1, s2  // 2.0 * 3.0 + 4.0 = 10.0
fmov w0, s3
brk #0"""
    write_test(f"{fp_dir}/fmadd_basic.s", config, asm, "FMADD basic")
    tests.append("fmadd_basic.s")
    
    # FMSUB
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """fmov s0, #2.0
fmov s1, #3.0
fmov s2, #4.0
fmsub s3, s0, s1, s2  // 2.0 * 3.0 - 4.0 = 2.0
fmov w0, s3
brk #0"""
    write_test(f"{fp_dir}/fmsub_basic.s", config, asm, "FMSUB basic")
    tests.append("fmsub_basic.s")
    
    return tests


def gen_branch_more_tests():
    """Generate more branch instruction tests."""
    branch_dir = os.path.join(BASE_DIR, "branch_more")
    os.makedirs(branch_dir, exist_ok=True)
    tests = []
    
    # CBZ - branch if zero
    config = {"RegData": {"X0": "0x000000000000000A"}}
    asm = """mov x0, #0
cbz x0, target
mov x0, #5
b done
target:
    mov x0, #10
done:
    brk #0"""
    write_test(f"{branch_dir}/cbz_taken.s", config, asm, "CBZ taken")
    tests.append("cbz_taken.s")
    
    # CBZ not taken
    config = {"RegData": {"X0": "0x0000000000000005"}}
    asm = """mov x0, #1
cbz x0, target
mov x0, #5
b done
target:
    mov x0, #10
done:
    brk #0"""
    write_test(f"{branch_dir}/cbz_not_taken.s", config, asm, "CBZ not taken")
    tests.append("cbz_not_taken.s")
    
    # CBNZ - branch if not zero
    config = {"RegData": {"X0": "0x000000000000000A"}}
    asm = """mov x0, #1
cbnz x0, target
mov x0, #5
b done
target:
    mov x0, #10
done:
    brk #0"""
    write_test(f"{branch_dir}/cbnz_taken.s", config, asm, "CBNZ taken")
    tests.append("cbnz_taken.s")
    
    # TBZ - test bit and branch if zero
    config = {"RegData": {"X0": "0x000000000000000A"}}
    asm = """mov x0, #2
tbz x0, #1, target   // bit 1 is set, not taken
mov x0, #5
b done
target:
    mov x0, #10
done:
    brk #0"""
    write_test(f"{branch_dir}/tbz_not_taken.s", config, asm, "TBZ not taken")
    tests.append("tbz_not_taken.s")
    
    # TBNZ - test bit and branch if not zero
    config = {"RegData": {"X0": "0x000000000000000A"}}
    asm = """mov x0, #2
tbnz x0, #1, target  // bit 1 is set, taken
mov x0, #5
b done
target:
    mov x0, #10
done:
    brk #0"""
    write_test(f"{branch_dir}/tbnz_taken.s", config, asm, "TBNZ taken")
    tests.append("tbnz_taken.s")
    
    # Conditional branch B.EQ
    config = {"RegData": {"X0": "0x000000000000000A"}}
    asm = """mov x0, #5
mov x1, #5
cmp x0, x1
b.eq target
mov x0, #5
b done
target:
    mov x0, #10
done:
    brk #0"""
    write_test(f"{branch_dir}/b_eq_taken.s", config, asm, "B.EQ taken")
    tests.append("b_eq_taken.s")
    
    # B.NE
    config = {"RegData": {"X0": "0x000000000000000A"}}
    asm = """mov x0, #5
mov x1, #3
cmp x0, x1
b.ne target
mov x0, #5
b done
target:
    mov x0, #10
done:
    brk #0"""
    write_test(f"{branch_dir}/b_ne_taken.s", config, asm, "B.NE taken")
    tests.append("b_ne_taken.s")
    
    # BL with return
    config = {"RegData": {"X0": "0x0000000000000015"}}
    asm = """mov x0, #10
bl add_five
brk #0

add_five:
    add x0, x0, #5
    ret"""
    write_test(f"{branch_dir}/bl_return.s", config, asm, "BL with return")
    tests.append("bl_return.s")
    
    return tests


def gen_bit_more_tests():
    """Generate more bit manipulation tests."""
    bit_dir = os.path.join(BASE_DIR, "bit_more")
    os.makedirs(bit_dir, exist_ok=True)
    tests = []
    
    # BFI - bit field insert
    config = {"RegData": {"X0": "0x0000000000000F00"}}
    asm = """mov x0, #0xFF
mov x1, #0
bfi x1, x0, #8, #8   // insert 8 bits of x0 at position 8
mov x0, x1
brk #0"""
    write_test(f"{bit_dir}/bfi_basic.s", config, asm, "BFI basic")
    tests.append("bfi_basic.s")
    
    # BFXIL - bit field extract and insert low
    config = {"RegData": {"X0": "0x00000000000000F0"}}
    asm = """mov x0, #0xFF00
mov x1, #0
bfxil x1, x0, #8, #8  // extract 8 bits from x0 at pos 8, insert at LSB
mov x0, x1
brk #0"""
    write_test(f"{bit_dir}/bfxil_basic.s", config, asm, "BFXIL basic")
    tests.append("bfxil_basic.s")
    
    # EXTR - extract register
    config = {"RegData": {"X0": "0x00000000000000FF"}}
    asm = """mov x0, #0xFF
mov x1, #0
extr x0, x0, x1, #0   // extract from x0:x1 at position 0
brk #0"""
    write_test(f"{bit_dir}/extr_basic.s", config, asm, "EXTR basic")
    tests.append("extr_basic.s")
    
    # TST - test bits
    config = {"RegData": {"X0": "0x0000000040000000"}}
    asm = """mov x0, #0xF
tst x0, #0xF          // 0xF & 0xF = 0xF, Z=0
mrs x0, nzcv
brk #0"""
    write_test(f"{bit_dir}/tst_basic.s", config, asm, "TST basic")
    tests.append("tst_basic.s")
    
    # MOVK - move keep
    config = {"RegData": {"X0": "0x0000000100000042"}}
    asm = """mov x0, #0x42
movk x0, #1, lsl #32
brk #0"""
    write_test(f"{bit_dir}/movk_basic.s", config, asm, "MOVK basic")
    tests.append("movk_basic.s")
    
    return tests


def main():
    print("Generating Phase 6 comprehensive A64 ASM tests...")
    
    div_tests = gen_div_boundary_tests()
    print(f"Generated {len(div_tests)} division boundary tests")
    
    csel_tests = gen_csel_boundary_tests()
    print(f"Generated {len(csel_tests)} conditional select tests")
    
    fp_tests = gen_fp_special_tests()
    print(f"Generated {len(fp_tests)} FP special value tests")
    
    branch_tests = gen_branch_more_tests()
    print(f"Generated {len(branch_tests)} branch tests")
    
    bit_tests = gen_bit_more_tests()
    print(f"Generated {len(bit_tests)} bit manipulation tests")
    
    total = len(div_tests) + len(csel_tests) + len(fp_tests) + len(branch_tests) + len(bit_tests)
    print(f"\nTotal: {total} new tests generated")


if __name__ == "__main__":
    main()
