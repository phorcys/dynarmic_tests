#!/usr/bin/env python3
"""
Comprehensive A64 test generator for dynarmic LoongArch64 backend.
Covers all instruction categories and edge cases.
"""
import os
from pathlib import Path
import json

TEST_DIR = str(Path(__file__).resolve().parent / "a64_comprehensive")

def gen_test(name, config_comment, code):
    """Generate a test file."""
    content = f"""/* CONFIG
{json.dumps(config_comment, indent=2)}
*/
{code}
"""
    with open(os.path.join(TEST_DIR, f"{name}.s"), "w") as f:
        f.write(content)

def main():
    os.makedirs(TEST_DIR, exist_ok=True)
    
    # ========== 整数算术指令 ==========
    
    # ADD extended register - 所有扩展类型
    for ext in ["uxtb", "uxth", "uxtw", "uxtx", "sxtb", "sxth", "sxtw", "sxtx"]:
        for shift in [0, 1, 2, 3, 4]:
            gen_test(f"add_ext_{ext}_lsl{shift}", {
                "Match": "All",
                "RegData": {"X0": "0x0000000000001234"}
            }, f"""
.text
.global _start
_start:
    mov x1, #0x8000
    movk x1, #0x8000, lsl #16
    movk x1, #0x8000, lsl #32
    movk x1, #0x8000, lsl #48  // x1 = 0x8000800080008000
    mov x0, #0x1000
    add x0, x0, x1, {ext}, lsl #{shift}
    brk #0
""")
    
    # ADD/SUB with carry - 长链测试
    gen_test("adc_long_chain", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000", "X1": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov x1, #0
    adds x0, x0, #1
    adcs x1, x1, xzr  // x1 = 0xFFFFFFFFFFFFFFFF, C=1
    adcs x1, x1, xzr  // x1 = 0x0000000000000000, C=1
    adc x0, xzr, xzr  // x0 = 1
    brk #0
""")
    
    # SUB extended register - 所有扩展类型
    for ext in ["uxtb", "uxth", "uxtw", "uxtx", "sxtb", "sxth", "sxtw", "sxtx"]:
        gen_test(f"sub_ext_{ext}", {
            "Match": "All",
            "RegData": {"X0": "0x0000000000007FFF"}
        }, f"""
.text
.global _start
_start:
    mov x1, #0xFF
    movk x1, #0xFF00, lsl #16  // x1 = 0x00FF0000FF
    mov x0, #0x8000
    sub x0, x0, x1, {ext}
    brk #0
""")
    
    # SBC 测试 - 借位链
    gen_test("sbc_chain", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000", "X1": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    subs x2, x0, #1      // Set C=0 (borrow)
    sbc x0, x0, xzr      // x0 = 0 - 0 - 1 = -1 = 0xFFFFFFFFFFFFFFFF
    sbc x1, xzr, xzr     // x1 = 0 - 0 - 1 = -1 (still borrowing)
    brk #0
""")
    
    # ========== 移位指令 ==========
    
    # ROR - 循环右移
    gen_test("ror_edge", {
        "Match": "All",
        "RegData": {"X0": "0xF00000000000000F"}
    }, """
.text
.global _start
_start:
    mov x0, #0xF
    movk x0, #0xF000, lsl #48  // x0 = 0xF00000000000000F
    ror x0, x0, #4              // 应该循环
    brk #0
""")
    
    # ROR register
    gen_test("ror_reg", {
        "Match": "All",
        "RegData": {"X0": "0x0F000000000000F0"}
    }, """
.text
.global _start
_start:
    mov x0, #0xF
    movk x0, #0xF000, lsl #48
    mov x1, #8
    ror x0, x0, x1
    brk #0
""")
    
    # ========== 位操作指令 ==========
    
    # BFI - 位域插入各种边界
    for lsb in [0, 8, 16, 24]:
        for width in [1, 8, 16]:
            gen_test(f"bfi_lsb{lsb}_w{width}", {
                "Match": "All",
                "RegData": {"X1": "0x00000000FFFFFFFF"}
            }, f"""
.text
.global _start
_start:
    mov x0, #0xFF
    movk x0, #0xFFFF, lsl #16
    movk x0, #0xFFFF, lsl #32  // x0 = all 1s
    mov x1, #0
    bfi x1, x0, #{lsb}, #{width}
    brk #0
""")
    
    # BFXIL - 位域提取插入
    gen_test("bfxil_basic", {
        "Match": "All",
        "RegData": {"X1": "0x000000000000FF78"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0x5678
    movk x1, #0x1234, lsl #16
    bfxil x1, x0, #0, #8
    brk #0
""")
    
    # SBFX/UBFX - 有符号/无符号位域提取
    gen_test("sbfx_negative", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFF8"}
    }, """
.text
.global _start
_start:
    mov x0, #0xF8
    movk x0, #0, lsl #16
    sbfx x0, x0, #3, #5  // 提取有符号位
    brk #0
""")
    
    gen_test("ubfx_basic", {
        "Match": "All",
        "RegData": {"X0": "0x000000000000001E"}
    }, """
.text
.global _start
_start:
    mov x0, #0xF8
    ubfx x0, x0, #2, #5
    brk #0
""")
    
    # ========== 比较指令 ==========
    
    # CCMP - 条件比较所有条件码
    for cond, cond_val in [("eq", 0), ("ne", 1), ("cs", 2), ("cc", 3), 
                           ("mi", 4), ("pl", 5), ("vs", 6), ("vc", 7),
                           ("hi", 8), ("ls", 9), ("ge", 10), ("lt", 11),
                           ("gt", 12), ("le", 13), ("al", 14)]:
        gen_test(f"ccmp_{cond}", {
            "Match": "All",
            "RegData": {"X0": "0x0000000010000000"}
        }, f"""
.text
.global _start
_start:
    mov x0, #0
    cmp x0, #0          // Z=1, C=1
    ccmp x0, #1, #0x8, {cond}  // if condition true, compare; else NZCV=0x8
    brk #0
""")
    
    # CCMN - 条件比较负数
    gen_test("ccmn_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000020000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    cmp x0, #0          // Z=1, C=1
    ccmn x0, #1, #0x0, eq  // if Z=1, compare x0 with -1
    brk #0
""")
    
    # ========== 条件选择指令 ==========
    
    # CSEL - 所有条件码
    for cond in ["eq", "ne", "cs", "cc", "mi", "pl", "vs", "vc",
                 "hi", "ls", "ge", "lt", "gt", "le"]:
        gen_test(f"csel_{cond}", {
            "Match": "All",
            "RegData": {"X0": "0x00000000000000AA"}
        }, f"""
.text
.global _start
_start:
    mov x0, #0xAA
    mov x1, #0xBB
    cmp xzr, xzr        // Z=1
    csel x0, x0, x1, {cond}
    brk #0
""")
    
    # CSINC/CSINV/CSNEG
    gen_test("csinc_basic", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000AA"}
    }, """
.text
.global _start
_start:
    mov x0, #0xA9
    cmp xzr, xzr
    csinc x0, x0, xzr, eq  // if Z=1, x0=x0; else x0=xzr+1
    brk #0
""")
    
    gen_test("csinv_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFF55"}
    }, """
.text
.global _start
_start:
    mov x0, #0xAA
    cmp xzr, xzr
    csinv x0, x0, xzr, eq  // if Z=1, x0=x0; else x0=~xzr
    brk #0
""")
    
    gen_test("csneg_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFF56"}
    }, """
.text
.global _start
_start:
    mov x0, #0xAA
    cmp xzr, xzr
    csneg x0, x0, xzr, eq  // if Z=1, x0=x0; else x0=-xzr
    brk #0
""")
    
    # CSET/CSETM
    gen_test("cset_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001", "X1": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    cmp xzr, xzr
    cset x0, eq
    cset x1, Ne
    brk #0
""")
    
    gen_test("csetm_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF", "X1": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    cmp xzr, xzr
    csetm x0, eq
    csetm x1, ne
    brk #0
""")
    
    # ========== 分支指令 ==========
    
    # B.cond - 所有条件分支
    for cond in ["eq", "ne", "cs", "cc", "mi", "pl", "vs", "vc",
                 "hi", "ls", "ge", "lt", "gt", "le"]:
        gen_test(f"bcond_{cond}", {
            "Match": "All",
            "RegData": {"X0": "0x0000000000000001"}
        }, f"""
.text
.global _start
_start:
    mov x0, #0
    cmp xzr, xzr
    b.{cond} 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0
""")
    
    # CBZ/CBNZ
    gen_test("cbz_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    cbz x0, 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0
""")
    
    gen_test("cbnz_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    cbnz x0, 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0
""")
    
    # TBZ/TBNZ
    gen_test("tbz_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov x1, #0
    tbz x1, #0, 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0
""")
    
    gen_test("tbnz_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    tbnz x1, #0, 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0
""")
    
    # ========== 乘法指令 ==========
    
    # MUL overflow
    gen_test("mul_overflow", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0x8000
    movk x0, #0, lsl #16
    mul x0, x0, x0     // 0x8000 * 0x8000 = 0x40000000 (no overflow in 64-bit)
    cmp x0, #0x40000000
    cset x0, eq
    brk #0
""")
    
    # SMULL/UMULL
    gen_test("smull_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFE0001"}
    }, """
.text
.global _start
_start:
    mov w1, #0xFFFF
    mov w2, #1
    smull x0, w1, w2   // -1 * 1 = -1 (sign extended)
    brk #0
""")
    
    gen_test("umull_basic", {
        "Match": "All",
        "RegData": {"X0": "0x00000000FFFE0001"}
    }, """
.text
.global _start
_start:
    mov w1, #0xFFFF
    mov w2, #1
    umull x0, w1, w2
    brk #0
""")
    
    # SMULH/UMULH - 高位乘法
    gen_test("smulh_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    mov x1, #0x8000
    movk x1, #0, lsl #16
    mov x2, #2
    smulh x0, x1, x2
    brk #0
""")
    
    # MADD/MSUB
    gen_test("madd_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000007"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    mov x1, #2
    mov x2, #3
    madd x0, x1, x2, x0  // 1 + 2*3 = 7
    brk #0
""")
    
    gen_test("msub_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFF9"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    mov x1, #2
    mov x2, #3
    msub x0, x1, x2, x0  // 1 - 2*3 = -5
    brk #0
""")
    
    # ========== 除法指令 ==========
    
    # SDIV/UDIV by zero
    gen_test("sdiv_zero", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #42
    mov x1, #0
    sdiv x0, x0, x1   // 除零 = 0
    brk #0
""")
    
    gen_test("udiv_zero", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #42
    mov x1, #0
    udiv x0, x0, x1
    brk #0
""")
    
    # SDIV negative
    gen_test("sdiv_negative", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFC"}
    }, """
.text
.global _start
_start:
    mov x0, #-12
    mov x1, #3
    sdiv x0, x0, x1   // -12 / 3 = -4
    brk #0
""")
    
    # ========== 饱和运算指令 ==========
    
    # SQADD/UQADD
    gen_test("sqadd_basic", {
        "Match": "All",
        "RegData": {"X0": "0x7FFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    mov x0, #0x7FFF
    movk x0, #0x7FFF, lsl #16
    movk x0, #0x7FFF, lsl #32
    movk x0, #0x7FFF, lsl #48  // x0 = 0x7FFF7FFF7FFF7FFF
    mov x1, #0x1000
    sqadd x0, x0, x1   // 饱和到 0x7FFFFFFFFFFFFFFF
    brk #0
""")
    
    gen_test("uqadd_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFFFF
    movk x0, #0xFFFF, lsl #16
    movk x0, #0xFFFF, lsl #32
    movk x0, #0xFFFF, lsl #48
    mov x1, #1
    uqadd x0, x0, x1   // 饱和到 0xFFFFFFFFFFFFFFFF
    brk #0
""")
    
    # SQSUB/UQSUB
    gen_test("sqsub_basic", {
        "Match": "All",
        "RegData": {"X0": "0x8000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    sqsub x0, x0, x1   // 0 - 1 = -1, 但有符号饱和到最小值
    brk #0
""")
    
    # ========== 计数指令 ==========
    
    # CLZ
    gen_test("clz_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000020"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    clz x0, x0        // 1 has 63 leading zeros
    brk #0
""")
    
    gen_test("clz_zero", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000040"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    clz x0, x0        // 0 has 64 leading zeros
    brk #0
""")
    
    # RBIT
    gen_test("rbit_basic", {
        "Match": "All",
        "RegData": {"X0": "0x8000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    rbit x0, x0       // reverse bits: 1 -> 0x8000000000000000
    brk #0
""")
    
    # REV/REV16/REV32
    gen_test("rev_basic", {
        "Match": "All",
        "RegData": {"X0": "0x7856341200000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0x12
    movk x0, #0x3456, lsl #16
    movk x0, #0x78, lsl #32
    rev32 x0, x0
    brk #0
""")
    
    # ========== 浮点指令 ==========
    
    # FADD/FSUB/FMUL/FDIV 边界条件
    gen_test("fadd_inf", {
        "Match": "All",
        "RegData": {"D0": "0x7FF0000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #2.0
    fadd d0, d0, d1
    brk #0
""")
    
    gen_test("fmul_zero", {
        "Match": "All",
        "VecData": {"D0": ["0x0000000000000000"]}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #0.0
    fmul d0, d0, d1
    brk #0
""")
    
    # FMAX/FMIN
    gen_test("fmax_basic", {
        "Match": "All",
        "VecData": {"D0": ["0x4000000000000000"]}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #2.0
    fmax d0, d0, d1   // max(1.0, 2.0) = 2.0
    brk #0
""")
    
    gen_test("fmin_basic", {
        "Match": "All",
        "VecData": {"D0": ["0x3FF0000000000000"]}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #2.0
    fmin d0, d0, d1
    brk #0
""")
    
    # FNMUL
    gen_test("fnmul_basic", {
        "Match": "All",
        "VecData": {"D0": ["0xC000000000000000"]}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #2.0
    fnmul d0, d0, d1  // -(1.0 * 2.0) = -2.0
    brk #0
""")
    
    # FSQRT
    gen_test("fsqrt_basic", {
        "Match": "All",
        "VecData": {"D0": ["0x4000000000000000"]}
    }, """
.text
.global _start
_start:
    fmov d0, #4.0
    fsqrt d0, d0
    brk #0
""")
    
    # FABS/FNEG
    gen_test("fabs_basic", {
        "Match": "All",
        "VecData": {"D0": ["0x4000000000000000"]}
    }, """
.text
.global _start
_start:
    fmov d0, #-2.0
    fabs d0, d0
    brk #0
""")
    
    gen_test("fneg_basic", {
        "Match": "All",
        "VecData": {"D0": ["0xC000000000000000"]}
    }, """
.text
.global _start
_start:
    fmov d0, #2.0
    fneg d0, d0
    brk #0
""")
    
    # FCMP
    gen_test("fcmp_eq", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #1.0
    fcmp d0, d1
    cset x0, eq
    brk #0
""")
    
    gen_test("fcmp_lt", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #2.0
    fcmp d0, d1
    cset x0, mi   // N=1 (d0 < d1)
    brk #0
""")
    
    # FCVT (float conversion)
    gen_test("fcvt_s_f", {
        "Match": "All",
        "VecData": {"S0": ["0x40000000"]}
    }, """
.text
.global _start
_start:
    fmov d0, #2.0
    fcvt s0, d0      // double to single
    brk #0
""")
    
    gen_test("fcvt_d_s", {
        "Match": "All",
        "VecData": {"D0": ["0x4000000000000000"]}
    }, """
.text
.global _start
_start:
    fmov s0, #2.0
    fcvt d0, s0      // single to double
    brk #0
""")
    
    # SCVTF/UCVTF (int to float)
    gen_test("scvtf_basic", {
        "Match": "All",
        "VecData": {"D0": ["0x4000000000000000"]}
    }, """
.text
.global _start
_start:
    mov x0, #2
    scvtf d0, x0
    brk #0
""")
    
    gen_test("ucvtf_basic", {
        "Match": "All",
        "VecData": {"D0": ["0x4000000000000000"]}
    }, """
.text
.global _start
_start:
    mov x0, #2
    ucvtf d0, x0
    brk #0
""")
    
    # FCVTZS/FCVTZU (float to int)
    gen_test("fcvtzs_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000002"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.9
    fcvtzs x0, d0
    brk #0
""")
    
    gen_test("fcvtzu_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000002"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.1
    fcvtzu x0, d0
    brk #0
""")
    
    # FMOV between GPR and FPR
    gen_test("fmov_gpr_fpr", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000042"}
    }, """
.text
.global _start
_start:
    mov x0, #0x42
    fmov d0, x0
    fmov x0, d0
    brk #0
""")
    
    # FRINTM/FRINTP/FRINTZ/FRINTA (rounding)
    gen_test("frintm_basic", {
        "Match": "All",
        "VecData": {"D0": ["0x4000000000000000"]}
    }, """
.text
.global _start
_start:
    fmov d0, #2.7
    frintm d0, d0    // round to -inf = 2.0
    brk #0
""")
    
    gen_test("frintp_basic", {
        "Match": "All",
        "VecData": {"D0": ["0x4008000000000000"]}
    }, """
.text
.global _start
_start:
    fmov d0, #2.7
    frintp d0, d0    // round to +inf = 3.0
    brk #0
""")
    
    gen_test("frintz_basic", {
        "Match": "All",
        "VecData": {"D0": ["0x4000000000000000"]}
    }, """
.text
.global _start
_start:
    fmov d0, #2.7
    frintz d0, d0    // round to zero = 2.0
    brk #0
""")
    
    # ========== 向量指令 (NEON) ==========
    
    # VADD
    gen_test("vadd_4s", {
        "Match": "All",
        "VecData": {"V0": ["0x0000000300000003", "0x0000000000000000"]}
    }, """
.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    add v0.4s, v0.4s, v1.4s
    brk #0
""")
    
    # VSUB
    gen_test("vsub_4s", {
        "Match": "All",
        "VecData": {"V0": ["0xFFFFFFFFFFFFFFFF", "0xFFFFFFFFFFFFFFFF"]}
    }, """
.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    sub v0.4s, v0.4s, v1.4s
    brk #0
""")
    
    # VMUL
    gen_test("vmul_4s", {
        "Match": "All",
        "VecData": {"V0": ["0x0000000600000006", "0x0000000600000006"]}
    }, """
.text
.global _start
_start:
    movi v0.4s, #2
    movi v1.4s, #3
    mul v0.4s, v0.4s, v1.4s
    brk #0
""")
    
    # VAND/VORR/VEOR/VBIC
    gen_test("vand_16b", {
        "Match": "All",
        "VecData": {"V0": ["0x00000000000000F0", "0x0000000000000000"]}
    }, """
.text
.global _start
_start:
    movi v0.16b, #0xFF
    movi v1.16b, #0xF0
    and v0.16b, v0.16b, v1.16b
    brk #0
""")
    
    gen_test("vorr_16b", {
        "Match": "All",
        "VecData": {"V0": ["0xFFFFFFFFFFFFFFFF", "0xFFFFFFFFFFFFFFFF"]}
    }, """
.text
.global _start
_start:
    movi v0.16b, #0x0F
    movi v1.16b, #0xF0
    orr v0.16b, v0.16b, v1.16b
    brk #0
""")
    
    gen_test("veor_16b", {
        "Match": "All",
        "VecData": {"V0": ["0xFFFFFFFFFFFFFFFF", "0xFFFFFFFFFFFFFFFF"]}
    }, """
.text
.global _start
_start:
    movi v0.16b, #0xFF
    movi v1.16b, #0xFF
    eor v0.16b, v0.16b, v1.16b
    brk #0
""")
    
    # ========== 内存指令 ==========
    
    # LDR/STR with various addressing modes
    gen_test("ldr_str_pre", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001234"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #32
    mov x0, #0x1234
    str x0, [sp, #8]!
    mov x0, #0
    ldr x0, [sp], #8
    add sp, sp, #8
    brk #0
""")
    
    gen_test("ldr_str_post", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001234"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #32
    mov x0, #0x1234
    str x0, [sp], #8
    mov x0, #0
    ldr x0, [sp, #-8]!
    add sp, sp, #16
    brk #0
""")
    
    # LDP/STP
    gen_test("ldp_stp_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001234", "X1": "0x0000000000005678"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #32
    mov x0, #0x1234
    mov x1, #0x5678
    stp x0, x1, [sp, #0]
    mov x0, #0
    mov x1, #0
    ldp x0, x1, [sp, #0]
    add sp, sp, #32
    brk #0
""")
    
    # LDUR/STUR (unscaled offset)
    gen_test("ldur_stur_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001234"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #32
    mov x0, #0x1234
    stur x0, [sp, #-8]
    mov x0, #0
    ldur x0, [sp, #-8]
    add sp, sp, #32
    brk #0
""")
    
    # LDXR/STXR (exclusive)
    gen_test("ldxr_stxr_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000", "X1": "0x0000000000001234"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #32
    mov x1, #0x1234
    stxr w0, x1, [sp]
    add sp, sp, #32
    brk #0
""")
    
    # ========== 系统指令 ==========
    
    # NZCV manipulation
    gen_test("msr_nzcv", {
        "Match": "All",
        "RegData": {"X0": "0x00000000F0000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0xF0000000
    msr nzcv, x0
    mrs x0, nzcv
    brk #0
""")
    
    # DMB/DSB/ISB (barriers)
    gen_test("dmb_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    dmb ish
    brk #0
""")
    
    gen_test("dsb_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    dsb ish
    brk #0
""")
    
    # ========== 特殊指令 ==========
    
    # MOV (alias)
    gen_test("mov_alias", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001234"}
    }, """
.text
.global _start
_start:
    mov x1, #0x1234
    mov x0, x1
    brk #0
""")
    
    # MOVK/MOVZ/MOVN
    gen_test("movk_basic", {
        "Match": "All",
        "RegData": {"X0": "0x123456789ABCDEF0"}
    }, """
.text
.global _start
_start:
    mov x0, #0xDEF0
    movk x0, #0x9ABC, lsl #16
    movk x0, #0x5678, lsl #32
    movk x0, #0x1234, lsl #48
    brk #0
""")
    
    gen_test("movn_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFF0FF"}
    }, """
.text
.global _start
_start:
    movn x0, #0xF00
    brk #0
""")
    
    # ADR/ADRP
    gen_test("adr_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000008"}
    }, """
.text
.global _start
_start:
    adr x0, _start
    brk #0
""")
    
    # EXTR (extract register)
    gen_test("extr_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001234"}
    }, """
.text
.global _start
_start:
    mov x0, #0x1234
    mov x1, #0
    extr x0, x1, x0, #0
    brk #0
""")
    
    # ========== 标志位测试 ==========
    
    # ADDS flags
    gen_test("adds_all_flags", {
        "Match": "All",
        "RegData": {"X0": "0x0000000030000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    adds x0, x0, #0    // Z=1, C=0, N=0, V=0 -> NZCV = 0x40000000
    mrs x1, nzcv
    mov x0, x1
    brk #0
""")
    
    # SUBS flags
    gen_test("subs_all_flags", {
        "Match": "All",
        "RegData": {"X0": "0x0000000030000000"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    subs x0, x0, #1    // Z=1, C=1, N=0, V=0 -> NZCV = 0x60000000
    mrs x1, nzcv
    mov x0, x1
    brk #0
""")
    
    # Register overlap tests
    gen_test("reg_overlap_add", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000004"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    add x0, x0, x0     // x0 = 1 + 1 = 2
    add x0, x0, x0     // x0 = 2 + 2 = 4
    brk #0
""")
    
    gen_test("reg_overlap_mul", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000010"}
    }, """
.text
.global _start
_start:
    mov x0, #2
    mul x0, x0, x0     // x0 = 2 * 2 = 4
    mul x0, x0, x0     // x0 = 4 * 4 = 16
    brk #0
""")
    
    print(f"Generated {len(os.listdir(TEST_DIR))} test files in {TEST_DIR}")

if __name__ == "__main__":
    main()
