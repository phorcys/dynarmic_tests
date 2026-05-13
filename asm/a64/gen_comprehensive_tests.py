#!/usr/bin/env python3
"""
Generate comprehensive A64 ASM tests for dynarmic LoongArch64 backend.
Covers: conditional instructions, branches, FLAGS, memory, floating-point edge cases.
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


def gen_conditional_tests():
    """Generate conditional instruction tests."""
    cond_dir = os.path.join(BASE_DIR, "conditional")
    os.makedirs(cond_dir, exist_ok=True)
    
    tests = []
    
    # CSEL tests - all conditions
    conditions = [
        ("eq", 0, "Z==1"),
        ("ne", 1, "Z==0"),
        ("cs", 2, "C==1"),
        ("cc", 3, "C==0"),
        ("mi", 4, "N==1"),
        ("pl", 5, "N==0"),
        ("vs", 6, "V==1"),
        ("vc", 7, "V==0"),
        ("hi", 8, "C==1 && Z==0"),
        ("ls", 9, "C==0 || Z==1"),
        ("ge", 10, "N==V"),
        ("lt", 11, "N!=V"),
        ("gt", 12, "Z==0 && N==V"),
        ("le", 13, "Z==1 || N!=V"),
        ("al", 14, "always"),
    ]
    
    for cond, code, desc in conditions:
        # CSEL with different flags states
        # Test EQ condition
        if cond == "eq":
            # Z=1 case
            config = {"RegData": {"X0": "0x0000000000000064"}}
            asm = f"""mov x1, #100
mov x2, #200
cmp x0, x0      // sets Z=1
csel x0, x1, x2, {cond}
brk #0"""
            write_test(f"{cond_dir}/csel_{cond}_true.s", config, asm, f"CSEL {cond} true: {desc}")
            tests.append(f"csel_{cond}_true.s")
            
            # Z=0 case
            config = {"RegData": {"X0": "0x00000000000000C8"}}
            asm = f"""mov x0, #1
mov x1, #100
mov x2, #200
cmp x0, #0      // sets Z=0
csel x0, x1, x2, {cond}
brk #0"""
            write_test(f"{cond_dir}/csel_{cond}_false.s", config, asm, f"CSEL {cond} false")
            tests.append(f"csel_{cond}_false.s")
    
    # CSET tests
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """cmp x0, x0      // Z=1
cset x0, eq
brk #0"""
    write_test(f"{cond_dir}/cset_eq.s", config, asm, "CSET when EQ true")
    tests.append("cset_eq.s")
    
    config = {"RegData": {"X0": "0x0000000000000000"}}
    asm = """mov x1, #1
cmp x1, #0      // Z=0
cset x0, eq
brk #0"""
    write_test(f"{cond_dir}/cset_eq_false.s", config, asm, "CSET when EQ false")
    tests.append("cset_eq_false.s")
    
    # CINC tests
    config = {"RegData": {"X0": "0x0000000000000002"}}
    asm = """mov x0, #1
cmp x0, x0      // Z=1
cinc x0, x0, eq
brk #0"""
    write_test(f"{cond_dir}/cinc_eq.s", config, asm, "CINC when condition true")
    tests.append("cinc_eq.s")
    
    # CSINC tests (conditional select increment)
    config = {"RegData": {"X0": "0x0000000000000065"}}
    asm = """mov x1, #100
mov x2, #200
cmp x0, x0      // Z=1
csinc x0, x1, x2, eq
brk #0"""
    write_test(f"{cond_dir}/csinc_eq.s", config, asm, "CSINC when condition true")
    tests.append("csinc_eq.s")
    
    # CINV tests (conditional invert)
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFF00"}}
    asm = """mov x0, #0xFF
mov x1, #1
cmp x1, #1      // Z=1
cinv x0, x0, eq
brk #0"""
    write_test(f"{cond_dir}/cinv_eq.s", config, asm, "CINV when condition true")
    tests.append("cinv_eq.s")
    
    # CNEG tests (conditional negate)
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFF9C"}}
    asm = """mov x0, #100
mov x1, #1
cmp x1, #1      // Z=1
cneg x0, x0, eq
brk #0"""
    write_test(f"{cond_dir}/cneg_eq.s", config, asm, "CNEG when condition true")
    tests.append("cneg_eq.s")
    
    # CCMP tests - conditional compare
    config = {"RegData": {"X0": "0x0000000000000000"}, "NZCV": "0x00000001"}
    asm = """mov x0, #0
mov x1, #1
cmp x0, #0      // Z=1
ccmp x1, #0, #1, eq  // if EQ, compare x1 with 0, set flags with #1 (C=1)
mrs x0, nzcv
brk #0"""
    write_test(f"{cond_dir}/ccmp_taken.s", config, asm, "CCMP when condition taken")
    tests.append("ccmp_taken.s")
    
    config = {"RegData": {"X0": "0x0000000000000000"}, "NZCV": "0x00000002"}
    asm = """mov x0, #0
mov x1, #1
mov x2, #2
cmp x0, #1      // Z=0 (NE)
ccmp x2, #2, #2, ne  // if NE, compare x2 with 2 -> equal, Z=1, but nzcv=2
mrs x0, nzcv
brk #0"""
    write_test(f"{cond_dir}/ccmp_not_taken.s", config, asm, "CCMP when condition not taken")
    tests.append("ccmp_not_taken.s")
    
    return tests


def gen_branch_tests():
    """Generate branch instruction tests."""
    branch_dir = os.path.join(BASE_DIR, "branch")
    os.makedirs(branch_dir, exist_ok=True)
    
    tests = []
    
    # B.cond tests
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #0
cmp x0, x0      // Z=1
b.eq taken
mov x0, #100
b end
taken:
mov x0, #1
end:
brk #0"""
    write_test(f"{branch_dir}/b_cond_eq_taken.s", config, asm, "B.EQ taken")
    tests.append("b_cond_eq_taken.s")
    
    config = {"RegData": {"X0": "0x0000000000000064"}}
    asm = """mov x0, #0
mov x1, #1
cmp x0, x1      // Z=0
b.eq taken
mov x0, #100
b end
taken:
mov x0, #1
end:
brk #0"""
    write_test(f"{branch_dir}/b_cond_eq_not_taken.s", config, asm, "B.EQ not taken")
    tests.append("b_cond_eq_not_taken.s")
    
    # CBZ tests
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #0
cbz x0, taken
mov x0, #100
b end
taken:
mov x0, #1
end:
brk #0"""
    write_test(f"{branch_dir}/cbz_taken.s", config, asm, "CBZ taken")
    tests.append("cbz_taken.s")
    
    config = {"RegData": {"X0": "0x0000000000000064"}}
    asm = """mov x0, #1
cbz x0, taken
mov x0, #100
b end
taken:
mov x0, #1
end:
brk #0"""
    write_test(f"{branch_dir}/cbz_not_taken.s", config, asm, "CBZ not taken")
    tests.append("cbz_not_taken.s")
    
    # CBNZ tests
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #1
cbnz x0, taken
mov x0, #100
b end
taken:
mov x0, #1
end:
brk #0"""
    write_test(f"{branch_dir}/cbnz_taken.s", config, asm, "CBNZ taken")
    tests.append("cbnz_taken.s")
    
    config = {"RegData": {"X0": "0x0000000000000064"}}
    asm = """mov x0, #0
cbnz x0, taken
mov x0, #100
b end
taken:
mov x0, #1
end:
brk #0"""
    write_test(f"{branch_dir}/cbnz_not_taken.s", config, asm, "CBNZ not taken")
    tests.append("cbnz_not_taken.s")
    
    # TBZ tests (test bit and branch if zero)
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #0
tbz x0, #0, taken
mov x0, #100
b end
taken:
mov x0, #1
end:
brk #0"""
    write_test(f"{branch_dir}/tbz_taken.s", config, asm, "TBZ taken (bit 0 is zero)")
    tests.append("tbz_taken.s")
    
    config = {"RegData": {"X0": "0x0000000000000064"}}
    asm = """mov x0, #1
tbz x0, #0, taken
mov x0, #100
b end
taken:
mov x0, #1
end:
brk #0"""
    write_test(f"{branch_dir}/tbz_not_taken.s", config, asm, "TBZ not taken (bit 0 is one)")
    tests.append("tbz_not_taken.s")
    
    # TBNZ tests (test bit and branch if non-zero)
    config = {"RegData": {"X0": "0x0000000000000001"}}
    asm = """mov x0, #1
tbnz x0, #0, taken
mov x0, #100
b end
taken:
mov x0, #1
end:
brk #0"""
    write_test(f"{branch_dir}/tbnz_taken.s", config, asm, "TBNZ taken (bit 0 is one)")
    tests.append("tbnz_taken.s")
    
    config = {"RegData": {"X0": "0x0000000000000064"}}
    asm = """mov x0, #0
tbnz x0, #0, taken
mov x0, #100
b end
taken:
mov x0, #1
end:
brk #0"""
    write_test(f"{branch_dir}/tbnz_not_taken.s", config, asm, "TBNZ not taken (bit 0 is zero)")
    tests.append("tbnz_not_taken.s")
    
    # BL/RET tests
    config = {"RegData": {"X0": "0x000000000000000E"}}
    asm = """mov x0, #0
bl add_ten
brk #0

add_ten:
add x0, x0, #10
ret"""
    write_test(f"{branch_dir}/bl_ret.s", config, asm, "BL and RET")
    tests.append("bl_ret.s")
    
    return tests


def gen_flags_boundary_tests():
    """Generate FLAGS boundary condition tests."""
    flags_dir = os.path.join(BASE_DIR, "flags_boundary")
    os.makedirs(flags_dir, exist_ok=True)
    
    tests = []
    
    # ADDS overflow - 64-bit
    config = {"RegData": {"X0": "0x8000000000000000"}, "NZCV": "0x0000000A"}
    asm = """mov x0, #0
movk x0, #0x8000, lsl #48  // min negative
adds x0, x0, x0            // overflow: N=1, V=1
mrs x1, nzcv
lsr x0, x1, #28            // extract N,Z,C,V bits
brk #0"""
    write_test(f"{flags_dir}/adds_64_overflow.s", config, asm, "ADDS 64-bit overflow")
    tests.append("adds_64_overflow.s")
    
    # ADDS carry - 64-bit
    config = {"RegData": {"X0": "0x0000000000000000"}, "NZCV": "0x00000002"}
    asm = """mov x0, #-1
adds x0, x0, #1            // carry out: C=1, Z=1
mrs x1, nzcv
lsr x0, x1, #28
brk #0"""
    write_test(f"{flags_dir}/adds_64_carry.s", config, asm, "ADDS 64-bit carry")
    tests.append("adds_64_carry.s")
    
    # SUBS underflow - 64-bit
    config = {"RegData": {"X0": "0x0000000000000000"}, "NZCV": "0x0000000B"}
    asm = """mov x0, #0
mov x1, #1
subs x0, x0, x1            // underflow: N=1, C=0, V=0, Z=0
mrs x2, nzcv
lsr x0, x2, #28
brk #0"""
    write_test(f"{flags_dir}/subs_64_underflow.s", config, asm, "SUBS 64-bit underflow")
    tests.append("subs_64_underflow.s")
    
    # 32-bit vs 64-bit FLAGS
    config = {"RegData": {"X0": "0x0000000000000000"}, "NZCV": "0x00000004"}
    asm = """mov w0, #-1
adds w0, w0, #1            // 32-bit: Z=1, C=1
mrs x1, nzcv
lsr x0, x1, #28
brk #0"""
    write_test(f"{flags_dir}/adds_32_carry.s", config, asm, "ADDS 32-bit carry")
    tests.append("adds_32_carry.s")
    
    # ADCS chain - multiple carry propagations
    config = {"NZCV": "0x00000002"}
    asm = """mov x0, #-1
mov x1, #0
mov x2, #0
adds x2, x1, #0            // clear flags, Z=1
adcs x0, x0, x0            // -1 + -1 + C=1 = -1 with carry
mrs x0, nzcv
brk #0"""
    write_test(f"{flags_dir}/adcs_chain.s", config, asm, "ADCS carry chain")
    tests.append("adcs_chain.s")
    
    # SBCS chain
    config = {"NZCV": "0x0000000A"}
    asm = """mov x0, #0
mov x1, #0
mov x2, #0
adds x2, x1, #0            // Z=1, C=1
sbcs x0, x0, x1            // 0 - 0 - !C = -1, N=1
mrs x0, nzcv
brk #0"""
    write_test(f"{flags_dir}/sbcs_chain.s", config, asm, "SBCS chain")
    tests.append("sbcs_chain.s")
    
    # NEGS (alias for SUBS)
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}, "NZCV": "0x0000000A"}
    asm = """mov x0, #0x7FFFFFFFFFFFFFFF
negs x0, x0                // negate max positive -> min negative, N=1, V=1
mrs x1, nzcv
lsr x0, x1, #28
brk #0"""
    write_test(f"{flags_dir}/negs_overflow.s", config, asm, "NEGS overflow")
    tests.append("negs_overflow.s")
    
    # CMP with various conditions
    config = {"NZCV": "0x00000000"}
    asm = """mov x0, #5
cmp x0, #10                // 5 < 10: N=0, Z=0, C=0, V=0
mrs x0, nzcv
brk #0"""
    write_test(f"{flags_dir}/cmp_less.s", config, asm, "CMP less than")
    tests.append("cmp_less.s")
    
    config = {"NZCV": "0x00000002"}
    asm = """mov x0, #10
cmp x0, #5                 // 10 > 5: N=0, Z=0, C=1, V=0
mrs x0, nzcv
brk #0"""
    write_test(f"{flags_dir}/cmp_greater.s", config, asm, "CMP greater than")
    tests.append("cmp_greater.s")
    
    config = {"NZCV": "0x00000006"}
    asm = """mov x0, #10
cmp x0, #10                // equal: Z=1, C=1
mrs x0, nzcv
brk #0"""
    write_test(f"{flags_dir}/cmp_equal.s", config, asm, "CMP equal")
    tests.append("cmp_equal.s")
    
    # Signed comparison FLAGS
    config = {"NZCV": "0x00000008"}
    asm = """mov x0, #-5
mov x1, #5
cmp x0, x1                 // -5 < 5: N=1, Z=0, C=0, V=0
mrs x0, nzcv
brk #0"""
    write_test(f"{flags_dir}/cmp_signed_less.s", config, asm, "CMP signed less")
    tests.append("cmp_signed_less.s")
    
    # Signed overflow detection
    config = {"NZCV": "0x0000000A"}
    asm = """mov x0, #0x7FFFFFFFFFFFFFFF  // max positive
mov x1, #1
adds x0, x0, x1            // overflow: N=1, V=1
mrs x0, nzcv
brk #0"""
    write_test(f"{flags_dir}/signed_overflow.s", config, asm, "Signed overflow")
    tests.append("signed_overflow.s")
    
    return tests


def gen_memory_boundary_tests():
    """Generate memory instruction boundary tests."""
    mem_dir = os.path.join(BASE_DIR, "memory_boundary")
    os.makedirs(mem_dir, exist_ok=True)
    
    tests = []
    
    # LDR with various offsets
    config = {"RegData": {"X0": "0x0000000000000042"}}
    asm = """mov x1, #0x100
mov x2, #0x42
str x2, [x1]
ldr x0, [x1]
brk #0"""
    write_test(f"{mem_dir}/ldr_basic.s", config, asm, "LDR basic")
    tests.append("ldr_basic.s")
    
    # LDR with pre-index
    config = {"RegData": {"X0": "0x0000000000000042", "X1": "0x0000000000000108"}}
    asm = """mov x1, #0x100
mov x2, #0x42
str x2, [x1, #8]!
ldr x0, [x1]
brk #0"""
    write_test(f"{mem_dir}/ldr_pre_index.s", config, asm, "LDR pre-index")
    tests.append("ldr_pre_index.s")
    
    # LDR with post-index
    config = {"RegData": {"X0": "0x0000000000000042", "X1": "0x0000000000000108"}}
    asm = """mov x1, #0x100
mov x2, #0x42
str x2, [x1], #8
mov x2, #0
ldr x0, [x1, #-8]
brk #0"""
    write_test(f"{mem_dir}/ldr_post_index.s", config, asm, "LDR post-index")
    tests.append("ldr_post_index.s")
    
    # LDP/STP
    config = {"RegData": {"X0": "0x0000000000000001", "X1": "0x0000000000000002"}}
    asm = """mov x2, #0x100
mov x0, #1
mov x1, #2
stp x0, x1, [x2]
ldp x0, x1, [x2]
brk #0"""
    write_test(f"{mem_dir}/ldp_stp.s", config, asm, "LDP/STP")
    tests.append("ldp_stp.s")
    
    # LDR sign-extend
    config = {"RegData": {"X0": "0xFFFFFFFFFFFFFF80"}}
    asm = """mov x1, #0x100
mov w2, #0xFFFFFF80
str w2, [x1]
ldrsb x0, [x1]
brk #0"""
    write_test(f"{mem_dir}/ldrsb_sign_extend.s", config, asm, "LDRSB sign extend")
    tests.append("ldrsb_sign_extend.s")
    
    # LDRH zero-extend
    config = {"RegData": {"X0": "0x0000000000008042"}}
    asm = """mov x1, #0x100
mov w2, #0x8042
strh w2, [x1]
ldrh w0, [x1]
brk #0"""
    write_test(f"{mem_dir}/ldrh_zero_extend.s", config, asm, "LDRH zero extend")
    tests.append("ldrh_zero_extend.s")
    
    # LDUR/STUR with negative offset
    config = {"RegData": {"X0": "0x0000000000000042"}}
    asm = """mov x1, #0x108
mov x2, #0x42
stur x2, [x1, #-8]
ldur x0, [x1, #-8]
brk #0"""
    write_test(f"{mem_dir}/ldur_negative.s", config, asm, "LDUR negative offset")
    tests.append("ldur_negative.s")
    
    return tests


def gen_fp_boundary_tests():
    """Generate floating-point boundary tests."""
    fp_dir = os.path.join(BASE_DIR, "fp_boundary")
    os.makedirs(fp_dir, exist_ok=True)
    
    tests = []
    
    # FADD with positive/negative
    config = {"RegData": {"X0": "0x0000000040400000"}}
    asm = """mov w0, #0x40000000    // 2.0f
mov w1, #0x40400000    // 3.0f
fmov s0, w0
fmov s1, w1
fadd s0, s0, s1        // 2.0 + 3.0 = 5.0
fmov w0, s0
brk #0"""
    write_test(f"{fp_dir}/fadd_positive.s", config, asm, "FADD positive")
    tests.append("fadd_positive.s")
    
    # FSUB
    config = {"RegData": {"X0": "0x000000003F800000"}}
    asm = """mov w0, #0x40000000    // 2.0f
mov w1, #0x3F800000    // 1.0f
fmov s0, w0
fmov s1, w1
fsub s0, s0, s1        // 2.0 - 1.0 = 1.0
fmov w0, s0
brk #0"""
    write_test(f"{fp_dir}/fsub_basic.s", config, asm, "FSUB basic")
    tests.append("fsub_basic.s")
    
    # FMUL
    config = {"RegData": {"X0": "0x0000000040800000"}}
    asm = """mov w0, #0x40000000    // 2.0f
mov w1, #0x40400000    // 3.0f
fmov s0, w0
fmov s1, w1
fmul s0, s0, s1        // 2.0 * 3.0 = 6.0
fmov w0, s0
brk #0"""
    write_test(f"{fp_dir}/fmul_basic.s", config, asm, "FMUL basic")
    tests.append("fmul_basic.s")
    
    # FDIV
    config = {"RegData": {"X0": "0x000000003F800000"}}
    asm = """mov w0, #0x40400000    // 3.0f
mov w1, #0x40000000    // 2.0f
fmov s0, w0
fmov s1, w1
fdiv s0, s0, s1        // 3.0 / 2.0 = 1.5
fmov w0, s0
brk #0"""
    write_test(f"{fp_dir}/fdiv_basic.s", config, asm, "FDIV basic")
    tests.append("fdiv_basic.s")
    
    # FSQRT
    config = {"RegData": {"X0": "0x000000003F800000"}}
    asm = """mov w0, #0x40400000    // 3.0f (actually we want 4.0)
mov w0, #0x40800000    // 4.0f
fmov s0, w0
fsqrt s0, s0           // sqrt(4.0) = 2.0
fmov w0, s0
brk #0"""
    write_test(f"{fp_dir}/fsqrt_basic.s", config, asm, "FSQRT basic")
    tests.append("fsqrt_basic.s")
    
    # FMAX/FMIN
    config = {"RegData": {"X0": "0x0000000040400000"}}
    asm = """mov w0, #0x40000000    // 2.0f
mov w1, #0x40400000    // 3.0f
fmov s0, w0
fmov s1, w1
fmax s0, s0, s1        // max(2.0, 3.0) = 3.0
fmov w0, s0
brk #0"""
    write_test(f"{fp_dir}/fmax_basic.s", config, asm, "FMAX basic")
    tests.append("fmax_basic.s")
    
    config = {"RegData": {"X0": "0x0000000040000000"}}
    asm = """mov w0, #0x40000000    // 2.0f
mov w1, #0x40400000    // 3.0f
fmov s0, w0
fmov s1, w1
fmin s0, s0, s1        // min(2.0, 3.0) = 2.0
fmov w0, s0
brk #0"""
    write_test(f"{fp_dir}/fmin_basic.s", config, asm, "FMIN basic")
    tests.append("fmin_basic.s")
    
    # FNEG
    config = {"RegData": {"X0": "0x00000000BF800000"}}
    asm = """mov w0, #0x3F800000    // 1.0f
fmov s0, w0
fneg s0, s0            // -1.0f
fmov w0, s0
brk #0"""
    write_test(f"{fp_dir}/fneg_basic.s", config, asm, "FNEG basic")
    tests.append("fneg_basic.s")
    
    # FABS
    config = {"RegData": {"X0": "0x000000003F800000"}}
    asm = """mov w0, #0xBF800000    // -1.0f
fmov s0, w0
fabs s0, s0            // |-1.0| = 1.0
fmov w0, s0
brk #0"""
    write_test(f"{fp_dir}/fabs_basic.s", config, asm, "FABS basic")
    tests.append("fabs_basic.s")
    
    # FCVT (single to double)
    config = {"RegData": {"X0": "0x0000000040000000"}}
    asm = """mov w0, #0x40000000    // 2.0f
fmov s0, w0
fcvt d0, s0            // convert to double
fcvt s0, d0            // convert back to single
fmov w0, s0
brk #0"""
    write_test(f"{fp_dir}/fcvt_s_d.s", config, asm, "FCVT single-double")
    tests.append("fcvt_s_d.s")
    
    # Double precision tests
    config = {"RegData": {"X0": "0x0000000040000000"}}
    asm = """mov x0, #0
movk x0, #0x4000, lsl #16  // 2.0 as double (low bits)
fmov d0, x0
fmov d1, x0
fadd d0, d0, d1            // 2.0 + 2.0 = 4.0
fmov x0, d0
brk #0"""
    write_test(f"{fp_dir}/fadd_double.s", config, asm, "FADD double")
    tests.append("fadd_double.s")
    
    return tests


def main():
    print("Generating comprehensive A64 ASM tests...")
    
    conditional_tests = gen_conditional_tests()
    print(f"Generated {len(conditional_tests)} conditional tests")
    
    branch_tests = gen_branch_tests()
    print(f"Generated {len(branch_tests)} branch tests")
    
    flags_tests = gen_flags_boundary_tests()
    print(f"Generated {len(flags_tests)} FLAGS boundary tests")
    
    memory_tests = gen_memory_boundary_tests()
    print(f"Generated {len(memory_tests)} memory boundary tests")
    
    fp_tests = gen_fp_boundary_tests()
    print(f"Generated {len(fp_tests)} FP boundary tests")
    
    total = len(conditional_tests) + len(branch_tests) + len(flags_tests) + len(memory_tests) + len(fp_tests)
    print(f"\nTotal: {total} new tests generated")


if __name__ == "__main__":
    main()
