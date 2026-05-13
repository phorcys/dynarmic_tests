#!/usr/bin/env python3
"""
A64 ASM Test Case Generator for dynarmic LoongArch64 Backend
Generates comprehensive test cases covering:
- Register overlap (same source and destination)
- Boundary conditions (overflow, underflow, zero, max, min)
- All condition codes for FLAGS
- Special floating point values (NaN, Infinity, Denormal)
"""

import os
import json

# Output directories
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
A64_DIR = os.path.join(BASE_DIR, "a64")
OVERLAP_DIR = os.path.join(A64_DIR, "register_overlap")
BOUNDARY_DIR = os.path.join(A64_DIR, "boundary")
SPECIAL_FP_DIR = os.path.join(A64_DIR, "special_fp")

def ensure_dir(path):
    os.makedirs(path, exist_ok=True)

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
        # Indent code properly
        for line in code.strip().split('\n'):
            f.write(f"    {line.strip()}\n")

def gen_all_tests():
    """Generate all test cases."""
    ensure_dir(OVERLAP_DIR)
    ensure_dir(BOUNDARY_DIR)
    ensure_dir(SPECIAL_FP_DIR)
    
    tests = []
    
    # ===== Register Overlap Tests =====
    
    # ADD self
    tests.append((OVERLAP_DIR, "add_self.s",
        {"RegData": {"X0": "0x000000000000002A"}},
        "mov x0, #21\nadd x0, x0, x0\nbrk #0",
        "ADD self: 21 + 21 = 42"))
    
    # ADD with shift
    tests.append((OVERLAP_DIR, "add_self_shift.s",
        {"RegData": {"X0": "0x0000000000000030"}},
        "mov x0, #10\nadd x0, x0, x0, lsl #1\nbrk #0",
        "ADD self with shift: 10 + (10<<1) = 30"))
    
    # ADDS self (zero result)
    tests.append((OVERLAP_DIR, "adds_self_zero.s",
        {"RegData": {"X0": "0x0000000000000000"}},
        "mov x0, #0\nadds x0, x0, x0\nbrk #0",
        "ADDS self zero: 0 + 0 = 0, Z=1"))
    
    # SUB self (always zero)
    tests.append((OVERLAP_DIR, "sub_self.s",
        {"RegData": {"X0": "0x0000000000000000"}},
        "mov x0, #42\nsub x0, x0, x0\nbrk #0",
        "SUB self: 42 - 42 = 0"))
    
    # NEGs self (negate)
    tests.append((OVERLAP_DIR, "neg_self.s",
        {"RegData": {"X0": "0xFFFFFFFFFFFFFFF6"}},
        "mov x0, #10\nneg x0, x0\nbrk #0",
        "NEG self: -10"))
    
    # AND self (identity)
    tests.append((OVERLAP_DIR, "and_self.s",
        {"RegData": {"X0": "0x00000000000000FF"}},
        "mov x0, #0xFF\nand x0, x0, x0\nbrk #0",
        "AND self: identity"))
    
    # ORR self (identity)
    tests.append((OVERLAP_DIR, "orr_self.s",
        {"RegData": {"X0": "0x00000000000000FF"}},
        "mov x0, #0xFF\norr x0, x0, x0\nbrk #0",
        "ORR self: identity"))
    
    # EOR self (zero)
    tests.append((OVERLAP_DIR, "eor_self.s",
        {"RegData": {"X0": "0x0000000000000000"}},
        "mov x0, #0xFF\neor x0, x0, x0\nbrk #0",
        "EOR self: always zero"))
    
    # BIC self (zero)
    tests.append((OVERLAP_DIR, "bic_self.s",
        {"RegData": {"X0": "0x0000000000000000"}},
        "mov x0, #0xFF\nbic x0, x0, x0\nbrk #0",
        "BIC self: always zero"))
    
    # EON self (all ones)
    tests.append((OVERLAP_DIR, "eon_self.s",
        {"RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}},
        "mov x0, #0xFF\neon x0, x0, x0\nbrk #0",
        "EON self: all ones"))
    
    # MVN self (bitwise NOT)
    tests.append((OVERLAP_DIR, "mvn_self.s",
        {"RegData": {"X0": "0xFFFFFFFFFFFFFF00"}},
        "mov x0, #0xFF\nmvn x0, x0\nbrk #0",
        "MVN self: bitwise NOT"))
    
    # MUL self (square)
    tests.append((OVERLAP_DIR, "mul_self_square.s",
        {"RegData": {"X0": "0x0000000000000031"}},
        "mov x0, #7\nmul x0, x0, x0\nbrk #0",
        "MUL self: 7*7 = 49"))
    
    # SDIV self (always 1, except zero)
    tests.append((OVERLAP_DIR, "sdiv_self.s",
        {"RegData": {"X0": "0x0000000000000001"}},
        "mov x0, #42\nsdiv x0, x0, x0\nbrk #0",
        "SDIV self: always 1"))
    
    # UDIV self (always 1, except zero)
    tests.append((OVERLAP_DIR, "udiv_self.s",
        {"RegData": {"X0": "0x0000000000000001"}},
        "mov x0, #42\nudiv x0, x0, x0\nbrk #0",
        "UDIV self: always 1"))
    
    # LSLV self
    tests.append((OVERLAP_DIR, "lslv_self.s",
        {"RegData": {"X0": "0x0000000000000002"}},
        "mov x0, #1\nmov x1, #1\nlslv x0, x0, x1\nbrk #0",
        "LSLV: 1 << 1 = 2"))
    
    # LSRV self with value
    tests.append((OVERLAP_DIR, "lsrv_self.s",
        {"RegData": {"X0": "0x0000000000000002"}},
        "mov x0, #8\nmov x1, #2\nlsrv x0, x0, x1\nbrk #0",
        "LSRV: 8 >> 2 = 2"))
    
    # ASRV (arithmetic shift right)
    tests.append((OVERLAP_DIR, "asrv_neg.s",
        {"RegData": {"X0": "0xFFFFFFFFFFFFFFFC"}},
        "mov x0, #-16\nmov x1, #2\nasrv x0, x0, x1\nbrk #0",
        "ASRV: -16 >> 2 = -4"))
    
    # RORV (rotate right)
    tests.append((OVERLAP_DIR, "rorv_test.s",
        {"RegData": {"X0": "0xC000000000000001"}},
        "mov x0, #3\nmov x1, #62\nrorv x0, x0, x1\nbrk #0",
        "RORV: 3 rotated by 62"))
    
    # ===== Boundary Condition Tests =====
    
    # 32-bit ADD overflow
    tests.append((BOUNDARY_DIR, "add_32bit_max.s",
        {"RegData": {"W0": "0x7FFFFFFF", "W1": "0x80000000"}},
        "mov w0, #0x7FFF\nmovk w0, #0x7FFF, lsl #16\nmov w1, #1\nadd w1, w0, w1\nbrk #0",
        "ADD 32-bit: max + 1 overflow"))
    
    # 64-bit ADD overflow
    tests.append((BOUNDARY_DIR, "add_64bit_overflow.s",
        {"RegData": {"X0": "0x90000000"}},
        "mov x0, #0x7FFF\nmovk x0, #0xFFFF, lsl #16\nmovk x0, #0xFFFF, lsl #32\nmovk x0, #0xFFFF, lsl #48\nmov x1, #1\nadds x2, x0, x1\nmrs x0, nzcv\nbrk #0",
        "ADD 64-bit overflow: sets N,V,C"))
    
    # SUB underflow
    tests.append((BOUNDARY_DIR, "sub_underflow.s",
        {"RegData": {"X0": "0x80000000"}},
        "mov x0, #0\nmov x1, #1\nsubs x2, x0, x1\nmrs x0, nzcv\nbrk #0",
        "SUB underflow: 0 - 1"))
    
    # Division by zero
    tests.append((BOUNDARY_DIR, "div_by_zero.s",
        {"RegData": {"X0": "0x0000000000000000"}},
        "mov x0, #42\nmov x1, #0\nudiv x0, x0, x1\nbrk #0",
        "Division by zero returns 0"))
    
    # SDIV min_int / -1
    tests.append((BOUNDARY_DIR, "sdiv_min_neg1.s",
        {"RegData": {"X0": "0x8000000000000000"}},
        "mov x0, #0x8000\nmovk x0, #0x0000, lsl #16\nmovk x0, #0x0000, lsl #32\nmovk x0, #0x0000, lsl #48\nmov x1, #-1\nsdiv x0, x0, x1\nbrk #0",
        "SDIV min_int / -1 overflow"))
    
    # MUL high bits
    tests.append((BOUNDARY_DIR, "mul_high_bits.s",
        {"RegData": {"X0": "0x0000000100000000"}},
        "mov x0, #0x10000\nmul x0, x0, x0\nbrk #0",
        "MUL produces high bits"))
    
    # SMULH (signed multiply high)
    tests.append((BOUNDARY_DIR, "smulh_test.s",
        {"RegData": {"X0": "0x0000000000000001"}},
        "mov x0, #-1\nmov x1, #-1\nsmulh x0, x0, x1\nbrk #0",
        "SMULH: (-1) * (-1) high = 1"))
    
    # UMULH (unsigned multiply high)
    tests.append((BOUNDARY_DIR, "umulh_test.s",
        {"RegData": {"X0": "0x0000000000000001"}},
        "mov x0, #0\nmovk x0, #0xFFFF, lsl #16\nmovk x0, #0xFFFF, lsl #32\nmovk x0, #0xFFFF, lsl #48\nmov x1, x0\numulh x0, x0, x1\nbrk #0",
        "UMULH: high bits of 2^64-1 squared"))
    
    # Zero operations
    tests.append((BOUNDARY_DIR, "zero_add.s",
        {"RegData": {"X0": "0x0000000000000000"}},
        "mov x0, #0\nadd x0, x0, x0\nbrk #0",
        "Zero + Zero = Zero"))
    
    tests.append((BOUNDARY_DIR, "zero_mul.s",
        {"RegData": {"X0": "0x0000000000000000"}},
        "mov x0, #42\nmov x1, #0\nmul x0, x0, x1\nbrk #0",
        "Any * Zero = Zero"))
    
    # ===== Special Floating Point Tests =====
    
    # NaN + NaN = NaN
    tests.append((SPECIAL_FP_DIR, "fadd_nan.s",
        {"RegData": {"S0": "0x7FC00000"}},
        "mov w0, #0x7FC0\nmovk w0, #0x0000, lsl #16\nfmov s0, w0\nfadd s0, s0, s0\nbrk #0",
        "NaN + NaN = NaN"))
    
    # Infinity + Infinity = Infinity
    tests.append((SPECIAL_FP_DIR, "fadd_inf.s",
        {"RegData": {"S0": "0x7F800000"}},
        "mov w0, #0x7F80\nmovk w0, #0x0000, lsl #16\nfmov s0, w0\nfadd s0, s0, s0\nbrk #0",
        "Inf + Inf = Inf"))
    
    # +Inf + -Inf = NaN
    tests.append((SPECIAL_FP_DIR, "fadd_inf_neg.s",
        {"RegData": {"S0": "0x7FC00000"}},
        "mov w0, #0x7F80\nmovk w0, #0x0000, lsl #16\nfmov s0, w0\nmov w1, #0xFF80\nmovk w1, #0x0000, lsl #16\nfmov s1, w1\nfadd s0, s0, s1\nbrk #0",
        "+Inf + -Inf = NaN"))
    
    # 0 + 0 = 0
    tests.append((SPECIAL_FP_DIR, "fadd_zero.s",
        {"RegData": {"S0": "0x00000000"}},
        "fmov s0, wzr\nfmov s1, wzr\nfadd s0, s0, s1\nbrk #0",
        "0.0 + 0.0 = 0.0"))
    
    # Denormal addition
    tests.append((SPECIAL_FP_DIR, "fadd_denormal.s",
        {"RegData": {"S0": "0x00000002"}},
        "mov w0, #1\nfmov s0, w0\nfadd s0, s0, s0\nbrk #0",
        "Denormal + Denormal"))
    
    # Inf / Inf = NaN
    tests.append((SPECIAL_FP_DIR, "fdiv_inf_inf.s",
        {"RegData": {"S0": "0x7FC00000"}},
        "mov w0, #0x7F80\nmovk w0, #0x0000, lsl #16\nfmov s0, w0\nfmov s1, s0\nfdiv s0, s0, s1\nbrk #0",
        "Inf / Inf = NaN"))
    
    # 0 / 0 = NaN
    tests.append((SPECIAL_FP_DIR, "fdiv_zero_zero.s",
        {"RegData": {"S0": "0x7FC00000"}},
        "fmov s0, wzr\nfmov s1, wzr\nfdiv s0, s0, s1\nbrk #0",
        "0 / 0 = NaN"))
    
    # sqrt(-1) = NaN
    tests.append((SPECIAL_FP_DIR, "fsqrt_neg.s",
        {"RegData": {"S0": "0x7FC00000"}},
        "mov w0, #0xBF80\nmovk w0, #0x0000, lsl #16\nfmov s0, w0\nfsqrt s0, s0\nbrk #0",
        "sqrt(-1) = NaN"))
    
    # sqrt(Inf) = Inf
    tests.append((SPECIAL_FP_DIR, "fsqrt_inf.s",
        {"RegData": {"S0": "0x7F800000"}},
        "mov w0, #0x7F80\nmovk w0, #0x0000, lsl #16\nfmov s0, w0\nfsqrt s0, s0\nbrk #0",
        "sqrt(Inf) = Inf"))
    
    # 1.0 / 0.0 = Inf
    tests.append((SPECIAL_FP_DIR, "fdiv_one_zero.s",
        {"RegData": {"S0": "0x7F800000"}},
        "mov w0, #0x3F80\nmovk w0, #0x0000, lsl #16\nfmov s0, w0\nfmov s1, wzr\nfdiv s0, s0, s1\nbrk #0",
        "1.0 / 0.0 = Inf"))
    
    # 0.0 / 1.0 = 0.0
    tests.append((SPECIAL_FP_DIR, "fdiv_zero_one.s",
        {"RegData": {"S0": "0x00000000"}},
        "fmov s0, wzr\nmov w1, #0x3F80\nmovk w1, #0x0000, lsl #16\nfmov s1, w1\nfdiv s0, s0, s1\nbrk #0",
        "0.0 / 1.0 = 0.0"))
    
    # Double: Inf + -Inf = NaN
    tests.append((SPECIAL_FP_DIR, "dadd_inf_neg.s",
        {"RegData": {"D0": "0x7FF8000000000000"}},
        "mov x0, #0x0000\nmovk x0, #0x0000, lsl #16\nmovk x0, #0x0000, lsl #32\nmovk x0, #0x7FF0, lsl #48\nfmov d0, x0\nmov x1, #0x0000\nmovk x1, #0x0000, lsl #16\nmovk x1, #0x0000, lsl #32\nmovk x1, #0xFFF0, lsl #48\nfmov d1, x1\nfadd d0, d0, d1\nbrk #0",
        "Double: +Inf + -Inf = NaN"))
    
    # ===== Vector Overlap Tests =====
    
    # Vector ADD self
    tests.append((OVERLAP_DIR, "vadd_self.s",
        {"VecData": {"V0": ["0x0000000200000002", "0x0000000200000002"]}},
        "mov x0, #1\ndup v0.4s, w0\nadd v0.4s, v0.4s, v0.4s\nbrk #0",
        "Vector ADD self: [1,1,1,1] + [1,1,1,1] = [2,2,2,2]"))
    
    # Vector MUL self
    tests.append((OVERLAP_DIR, "vmul_self.s",
        {"VecData": {"V0": ["0x0000000400000004", "0x0000000400000004"]}},
        "mov x0, #2\ndup v0.4s, w0\nmul v0.4s, v0.4s, v0.4s\nbrk #0",
        "Vector MUL self: [2,2,2,2] * [2,2,2,2] = [4,4,4,4]"))
    
    # Vector SUB self
    tests.append((OVERLAP_DIR, "vsub_self.s",
        {"VecData": {"V0": ["0x0000000000000000", "0x0000000000000000"]}},
        "mov x0, #42\ndup v0.4s, w0\nsub v0.4s, v0.4s, v0.4s\nbrk #0",
        "Vector SUB self: all zeros"))
    
    # Vector AND self
    tests.append((OVERLAP_DIR, "vand_self.s",
        {"VecData": {"V0": ["0xFFFFFFFFFFFFFFFF", "0xFFFFFFFFFFFFFFFF"]}},
        "mov x0, #-1\ndup v0.2d, x0\nand v0.16b, v0.16b, v0.16b\nbrk #0",
        "Vector AND self: identity"))
    
    # Vector EOR self
    tests.append((OVERLAP_DIR, "veor_self.s",
        {"VecData": {"V0": ["0x0000000000000000", "0x0000000000000000"]}},
        "mov x0, #0xFF\ndup v0.2d, x0\neor v0.16b, v0.16b, v0.16b\nbrk #0",
        "Vector EOR self: all zeros"))
    
    # Write all tests
    total = 0
    for out_dir, filename, config, code, desc in tests:
        filepath = os.path.join(out_dir, filename)
        write_test(filepath, config, code, desc)
        total += 1
        print(f"Generated: {filepath}")
    
    print(f"\nTotal tests generated: {total}")

if __name__ == "__main__":
    gen_all_tests()