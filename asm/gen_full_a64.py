#!/usr/bin/env python3
"""
Generate comprehensive A64 tests covering all instruction categories.
"""
import os
from pathlib import Path
import json

TEST_DIR = str(Path(__file__).resolve().parent / "a64_full")

def gen_test(name, config, code):
    content = f"""/* CONFIG
{json.dumps(config, indent=2)}
*/
{code}
"""
    os.makedirs(TEST_DIR, exist_ok=True)
    with open(os.path.join(TEST_DIR, f"{name}.s"), "w") as f:
        f.write(content)

def main():
    
    # ========== 整数算术扩展测试 ==========
    
    # ADD 扩展寄存器所有类型
    for ext in ["uxtb", "uxth", "uxtw", "sxtb", "sxth", "sxtw"]:
        sign = "-" if ext.startswith("sx") else ""
        val = "0x80" if ext.startswith("sx") else "0xFF"
        if ext in ["uxtb", "sxtb"]:
            bits = 8
        elif ext in ["uxth", "sxth"]:
            bits = 16
        else:
            bits = 32
        
        if ext.startswith("sx"):
            expected = "0xFFFFFFFFFFFFFF80"  # sign extend 0x80 = -128
        else:
            expected = f"0x{val[2:]}"  # zero extend
        
        gen_test(f"add_ext_{ext}", {
            "Match": "All",
            "RegData": {"X0": expected}
        }, f"""
.text
.global _start
_start:
    mov x0, #0
    mov x1, #{val}
    add x0, x0, x1, {ext}
    brk #0
""")
    
    # ADD 移位变体
    for shift in ["lsl", "lsr", "asr", "ror"]:
        for amt in [0, 4, 31]:
            if shift == "lsl":
                gen_test(f"add_{shift}_{amt}", {
                    "Match": "All",
                    "RegData": {"X0": hex(1 + (1 << amt) if amt < 31 else 0)}
                }, f"""
.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    add x0, x0, x1, {shift} #{amt}
    brk #0
""")
            elif shift == "lsr":
                gen_test(f"add_{shift}_{amt}", {
                    "Match": "All",
                    "RegData": {"X0": "0x1"}
                }, f"""
.text
.global _start
_start:
    mov x0, #1
    mov x1, #0x10
    add x0, x0, x1, {shift} #4
    brk #0
""")
    
    # SUB 扩展寄存器
    gen_test("sub_ext_uxtb", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0x100
    mov x1, #0xFF
    sub x0, x0, x1, uxtb  // 0x100 - 0xFF = 1
    brk #0
""")
    
    # ADC/SBC 链式测试
    gen_test("adc_chain", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000003", "X1": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    subs xzr, x1, #0     // C=1
    adc x0, x0, x1       // x0 = 1 + 1 + 1 = 3
    adcs xzr, xzr, xzr   // C=0
    adc x1, xzr, xzr     // x1 = 0 + 0 + 0 = 0
    brk #0
""")
    
    gen_test("sbc_chain", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000", "X1": "0x0000000000000002"}
    }, """
.text
.global _start
_start:
    mov x0, #5
    mov x1, #3
    subs xzr, x0, x0     // C=1 (no borrow)
    sbc x0, x0, x1       // x0 = 5 - 3 - 0 = 2
    subs xzr, xzr, x1    // C=0 (borrow: 0 - 3)
    sbc x1, xzr, xzr     // x1 = 0 - 0 - 1 = -1 = 0xFFFFFFFFFFFFFFFF
    add x1, x1, #3       // x1 = 2
    brk #0
""")
    
    # ========== 乘法扩展测试 ==========
    
    # MUL 32位
    gen_test("mul_32bit", {
        "Match": "All",
        "RegData": {"W0": "0x00000006"}
    }, """
.text
.global _start
_start:
    mov w0, #2
    mov w1, #3
    mul w0, w0, w1
    brk #0
""")
    
    # MADD 32位
    gen_test("madd_32bit", {
        "Match": "All",
        "RegData": {"W0": "0x00000007"}
    }, """
.text
.global _start
_start:
    mov w0, #1
    mov w1, #2
    mov w2, #3
    madd w0, w1, w2, w0  // 1 + 2*3 = 7
    brk #0
""")
    
    # SMULL 边界
    gen_test("smull_neg", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFF0"}
    }, """
.text
.global _start
_start:
    mov w1, #0xFFFFFFF0  // -16
    mov w2, #1
    smull x0, w1, w2     // -16 * 1 = -16
    brk #0
""")
    
    # UMULL 边界
    gen_test("umull_max", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFE00000001"}
    }, """
.text
.global _start
_start:
    mov w1, #0xFFFFFFFF
    mov w2, #0xFFFFFFFF
    umull x0, w1, w2
    brk #0
""")
    
    # SMULH 高位乘法
    gen_test("smulh_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    mov x1, #0x7FFFFFFFFFFFFFFF
    mov x2, #1
    smulh x0, x1, x2
    brk #0
""")
    
    # UMULH 高位乘法
    gen_test("umulh_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    mov x1, #0xFFFFFFFF
    mov x2, #0xFFFFFFFF
    umulh x0, x1, x2
    brk #0
""")
    
    # ========== 除法测试 ==========
    
    # SDIV 负数
    gen_test("sdiv_neg", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFC"}
    }, """
.text
.global _start
_start:
    mov x0, #-12
    mov x1, #3
    sdiv x0, x0, x1
    brk #0
""")
    
    # SDIV 除零
    gen_test("sdiv_zero", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #42
    mov x1, #0
    sdiv x0, x0, x1
    brk #0
""")
    
    # UDIV 除零
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
    
    # ========== 移位边界测试 ==========
    
    # LSL 边界
    gen_test("lsl_63", {
        "Match": "All",
        "RegData": {"X0": "0x8000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    lsl x0, x0, #63
    brk #0
""")
    
    gen_test("lsl_reg_63", {
        "Match": "All",
        "RegData": {"X0": "0x8000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    mov x1, #63
    lsl x0, x0, x1
    brk #0
""")
    
    # LSR 边界
    gen_test("lsr_63", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0x8000000000000000
    lsr x0, x0, #63
    brk #0
""")
    
    # ASR 边界
    gen_test("asr_63", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    mov x0, #0x8000000000000000
    asr x0, x0, #63
    brk #0
""")
    
    # ROR 边界
    gen_test("ror_32", {
        "Match": "All",
        "RegData": {"X0": "0x0000000100000000"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    ror x0, x0, #32
    brk #0
""")
    
    # ========== 位操作边界测试 ==========
    
    # BFI 各种位置
    gen_test("bfi_lsb0_w8", {
        "Match": "All",
        "RegData": {"X1": "0x00000000000000FF"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    bfi x1, x0, #0, #8
    brk #0
""")
    
    gen_test("bfi_lsb16_w8", {
        "Match": "All",
        "RegData": {"X1": "0x0000000000FF0000"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    bfi x1, x0, #16, #8
    brk #0
""")
    
    gen_test("bfi_lsb56_w8", {
        "Match": "All",
        "RegData": {"X1": "0xFF00000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    bfi x1, x0, #56, #8
    brk #0
""")
    
    # BFXIL
    gen_test("bfxil_basic", {
        "Match": "All",
        "RegData": {"X1": "0x00000000000000FF"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    bfxil x1, x0, #0, #8
    brk #0
""")
    
    # UBFX
    gen_test("ubfx_lsb8_w8", {
        "Match": "All",
        "RegData": {"X0": "0x000000000000000F"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF00
    ubfx x0, x0, #8, #8
    brk #0
""")
    
    # SBFX 有符号扩展
    gen_test("sbfx_sign_extend", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFF0"}
    }, """
.text
.global _start
_start:
    mov x0, #0x78       // 0b01111000, bit 3 is set
    sbfx x0, x0, #0, #4  // extract bits [3:0] = 0b1000, sign extend
    brk #0
""")
    
    # ========== 条件选择测试 ==========
    
    # CSEL 所有条件
    conditions = [
        ("eq", "Z=1", "0xAA", "0xBB"),
        ("ne", "Z=0", "0xBB", "0xAA"),
        ("cs", "C=1", "0xAA", "0xBB"),
        ("cc", "C=0", "0xBB", "0xAA"),
        ("mi", "N=1", "0xBB", "0xAA"),
        ("pl", "N=0", "0xAA", "0xBB"),
        ("vs", "V=1", "0xBB", "0xAA"),
        ("vc", "V=0", "0xAA", "0xBB"),
        ("hi", "C=1 && Z=0", "0xBB", "0xAA"),
        ("ls", "C=0 || Z=1", "0xAA", "0xBB"),
        ("ge", "N==V", "0xAA", "0xBB"),
        ("lt", "N!=V", "0xBB", "0xAA"),
        ("gt", "Z==0 && N==V", "0xBB", "0xAA"),
        ("le", "Z==1 || N!=V", "0xAA", "0xBB"),
    ]
    
    for cond, desc, exp1, exp2 in conditions:
        gen_test(f"csel_{cond}", {
            "Match": "All",
            "RegData": {"X0": f"0x000000000000{exp1}"}
        }, f"""
.text
.global _start
_start:
    mov x0, #0xAA
    mov x1, #0xBB
    cmp xzr, xzr        // Z=1, C=1, N=0, V=0
    csel x0, x0, x1, {cond}
    brk #0
""")
    
    # CSINC
    gen_test("csinc_eq", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000AA"}
    }, """
.text
.global _start
_start:
    mov x0, #0xAA
    cmp xzr, xzr
    csinc x0, x0, xzr, eq  // if Z=1: x0 = x0
    brk #0
""")
    
    gen_test("csinc_ne", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    cmp xzr, xzr        // Z=1
    csinc x0, x0, xzr, ne  // if Z=0: x0 = xzr + 1 = 1; else x0 = x0
    brk #0
""")
    
    # CSINV
    gen_test("csinv_eq", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000AA"}
    }, """
.text
.global _start
_start:
    mov x0, #0xAA
    cmp xzr, xzr
    csinv x0, x0, xzr, eq
    brk #0
""")
    
    # CSNEG
    gen_test("csneg_eq", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000AA"}
    }, """
.text
.global _start
_start:
    mov x0, #0xAA
    cmp xzr, xzr
    csneg x0, x0, xzr, eq
    brk #0
""")
    
    # CSET/CSETM
    gen_test("cset_eq", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    cmp xzr, xzr
    cset x0, eq
    brk #0
""")
    
    gen_test("csetm_eq", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    cmp xzr, xzr
    csetm x0, eq
    brk #0
""")
    
    # ========== CCMP 测试 ==========
    
    gen_test("ccmp_eq_taken", {
        "Match": "All",
        "RegData": {"X0": "0x0000000060000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    cmp x0, #0          // Z=1, C=1
    ccmp x0, #0, #0x0, eq  // if Z=1: compare 0 with 0 -> Z=1, C=1
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("ccmp_eq_not_taken", {
        "Match": "All",
        "RegData": {"X0": "0x000000000000000F"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    cmp x0, #1          // Z=0, C=0
    ccmp x0, #0, #0xF, eq  // if Z=0: NZCV = 0xF
    mrs x0, nzcv
    brk #0
""")
    
    # ========== 分支测试 ==========
    
    # B.cond
    gen_test("b_eq_taken", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    cmp xzr, xzr
    b.eq 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0
""")
    
    gen_test("b_ne_not_taken", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    cmp xzr, xzr        // Z=1
    b.ne 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0
""")
    
    # CBZ/CBNZ
    gen_test("cbz_taken", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov x1, #0
    cbz x1, 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0
""")
    
    gen_test("cbnz_taken", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    cbnz x1, 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0
""")
    
    # TBZ/TBNZ
    gen_test("tbz_bit0", {
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
    
    gen_test("tbnz_bit0", {
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
    
    gen_test("tbz_bit63", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov x1, #0
    movk x1, #0, lsl #48
    tbz x1, #63, 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0
""")
    
    # ========== 浮点测试 ==========
    
    # FADD
    gen_test("fadd_basic", {
        "Match": "All",
        "RegData": {"X0": "0x4008000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #2.0
    fadd d0, d0, d1
    fmov x0, d0
    brk #0
""")
    
    # FSUB
    gen_test("fsub_basic", {
        "Match": "All",
        "RegData": {"X0": "0x3FF0000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.0
    fmov d1, #1.0
    fsub d0, d0, d1
    fmov x0, d0
    brk #0
""")
    
    # FMUL
    gen_test("fmul_basic", {
        "Match": "All",
        "RegData": {"X0": "0x4010000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.0
    fmov d1, #2.0
    fmul d0, d0, d1
    fmov x0, d0
    brk #0
""")
    
    # FDIV
    gen_test("fdiv_basic", {
        "Match": "All",
        "RegData": {"X0": "0x3FF0000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.0
    fmov d1, #2.0
    fdiv d0, d0, d1
    fmov x0, d0
    brk #0
""")
    
    # FMAX/FMIN
    gen_test("fmax_basic", {
        "Match": "All",
        "RegData": {"X0": "0x4000000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #2.0
    fmax d0, d0, d1
    fmov x0, d0
    brk #0
""")
    
    gen_test("fmin_basic", {
        "Match": "All",
        "RegData": {"X0": "0x3FF0000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #2.0
    fmin d0, d0, d1
    fmov x0, d0
    brk #0
""")
    
    # FNMUL
    gen_test("fnmul_basic", {
        "Match": "All",
        "RegData": {"X0": "0xC000000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #2.0
    fnmul d0, d0, d1
    fmov x0, d0
    brk #0
""")
    
    # FSQRT
    gen_test("fsqrt_basic", {
        "Match": "All",
        "RegData": {"X0": "0x4000000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #4.0
    fsqrt d0, d0
    fmov x0, d0
    brk #0
""")
    
    # FABS
    gen_test("fabs_basic", {
        "Match": "All",
        "RegData": {"X0": "0x4000000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #-2.0
    fabs d0, d0
    fmov x0, d0
    brk #0
""")
    
    # FNEG
    gen_test("fneg_basic", {
        "Match": "All",
        "RegData": {"X0": "0xC000000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.0
    fneg d0, d0
    fmov x0, d0
    brk #0
""")
    
    # FCMP
    gen_test("fcmp_eq", {
        "Match": "All",
        "RegData": {"X0": "0x0000000060000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #1.0
    fcmp d0, d1
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("fcmp_lt", {
        "Match": "All",
        "RegData": {"X0": "0x0000000080000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #2.0
    fcmp d0, d1
    mrs x0, nzcv  // N=1 -> 0x80000000
    brk #0
""")
    
    # FCVT
    gen_test("fcvt_s_d", {
        "Match": "All",
        "RegData": {"X0": "0x0000000040000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.0
    fcvt s0, d0
    fmov w0, s0
    brk #0
""")
    
    gen_test("fcvt_d_s", {
        "Match": "All",
        "RegData": {"X0": "0x4000000000000000"}
    }, """
.text
.global _start
_start:
    fmov s0, #2.0
    fcvt d0, s0
    fmov x0, d0
    brk #0
""")
    
    # SCVTF/UCVTF
    gen_test("scvtf_basic", {
        "Match": "All",
        "RegData": {"X0": "0x4000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #2
    scvtf d0, x0
    fmov x0, d0
    brk #0
""")
    
    gen_test("ucvtf_basic", {
        "Match": "All",
        "RegData": {"X0": "0x4000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #2
    ucvtf d0, x0
    fmov x0, d0
    brk #0
""")
    
    # FCVTZS/FCVTZU
    gen_test("fcvtzs_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000002"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.5
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
    fmov d0, #2.5
    fcvtzu x0, d0
    brk #0
""")
    
    # FRINT
    gen_test("frintm_basic", {
        "Match": "All",
        "RegData": {"X0": "0x4000000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.5
    frintm d0, d0  // round to -inf
    fmov x0, d0
    brk #0
""")
    
    gen_test("frintp_basic", {
        "Match": "All",
        "RegData": {"X0": "0x4008000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.5
    frintp d0, d0  // round to +inf
    fmov x0, d0
    brk #0
""")
    
    gen_test("frintz_basic", {
        "Match": "All",
        "RegData": {"X0": "0x4000000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.5
    frintz d0, d0  // round to zero
    fmov x0, d0
    brk #0
""")
    
    gen_test("frintn_basic", {
        "Match": "All",
        "RegData": {"X0": "0x4000000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.5
    frintn d0, d0  // round to nearest
    fmov x0, d0
    brk #0
""")
    
    # ========== 向量测试 ==========
    
    # VADD
    gen_test("vadd_4s", {
        "Match": "All",
        "RegData": {"X0": "0x0000000300000003"}
    }, """
.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    add v0.4s, v0.4s, v1.4s
    mov x0, v0.d[0]
    brk #0
""")
    
    # VSUB
    gen_test("vsub_4s", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    sub v0.4s, v0.4s, v1.4s
    mov x0, v0.d[0]
    brk #0
""")
    
    # VMUL
    gen_test("vmul_4s", {
        "Match": "All",
        "RegData": {"X0": "0x0000000600000006"}
    }, """
.text
.global _start
_start:
    movi v0.4s, #2
    movi v1.4s, #3
    mul v0.4s, v0.4s, v1.4s
    mov x0, v0.d[0]
    brk #0
""")
    
    # VAND/VORR/VEOR
    gen_test("vand_16b", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000F0"}
    }, """
.text
.global _start
_start:
    movi v0.16b, #0xFF
    movi v1.16b, #0xF0
    and v0.16b, v0.16b, v1.16b
    mov x0, v0.d[0]
    brk #0
""")
    
    gen_test("vorr_16b", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    movi v0.16b, #0x0F
    movi v1.16b, #0xF0
    orr v0.16b, v0.16b, v1.16b
    mov x0, v0.d[0]
    brk #0
""")
    
    gen_test("veor_16b", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    movi v0.16b, #0xFF
    movi v1.16b, #0xFF
    eor v0.16b, v0.16b, v1.16b
    mov x0, v0.d[0]
    brk #0
""")
    
    # ========== 内存测试 ==========
    
    # LDR/STR
    gen_test("ldr_str_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001234"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #16
    mov x0, #0x1234
    str x0, [sp]
    mov x0, #0
    ldr x0, [sp]
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
    sub sp, sp, #16
    mov x0, #0x1234
    mov x1, #0x5678
    stp x0, x1, [sp]
    mov x0, #0
    mov x1, #0
    ldp x0, x1, [sp]
    add sp, sp, #16
    brk #0
""")
    
    # LDUR/STUR
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
    
    # LDR with pre/post index
    gen_test("ldr_pre_index", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001234", "X1": "0x0000000000001008"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #32
    mov x0, #0x1234
    str x0, [sp, #8]
    mov x0, #0
    mov x1, sp
    ldr x0, [x1, #8]!
    add sp, sp, #32
    brk #0
""")
    
    # ========== 特殊指令 ==========
    
    # CLZ
    gen_test("clz_basic", {
        "Match": "All",
        "RegData": {"X0": "0x000000000000003F"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    clz x0, x0
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
    clz x0, x0
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
    rbit x0, x0
    brk #0
""")
    
    # REV
    gen_test("rev16_basic", {
        "Match": "All",
        "RegData": {"X0": "0x3412785600000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0x12
    movk x0, #0x3456, lsl #16
    movk x0, #0x78, lsl #32
    rev16 x0, x0
    brk #0
""")
    
    gen_test("rev32_basic", {
        "Match": "All",
        "RegData": {"X0": "0x7800000012005634"}
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
    
    gen_test("rev64_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0056341200000078"}
    }, """
.text
.global _start
_start:
    mov x0, #0x78
    movk x0, #0x1234, lsl #16
    movk x0, #0x56, lsl #32
    rev64 x0, x0
    brk #0
""")
    
    # EXTR
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
    
    # MOVK/MOVZ/MOVN
    gen_test("movk_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000010000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    movk x0, #1, lsl #16
    brk #0
""")
    
    gen_test("movz_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000010000"}
    }, """
.text
.global _start
_start:
    movz x0, #1, lsl #16
    brk #0
""")
    
    gen_test("movn_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFE"}
    }, """
.text
.global _start
_start:
    movn x0, #1
    brk #0
""")
    
    # ========== 标志位边界测试 ==========
    
    gen_test("adds_overflow", {
        "Match": "All",
        "RegData": {"X0": "0x0000000030000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0x7FFFFFFFFFFFFFFF
    adds x0, x0, #1  // Overflow: V=1, N=1
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("subs_borrow", {
        "Match": "All",
        "RegData": {"X0": "0x0000000020000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    subs x0, x0, #1  // Borrow: C=0, N=1
    mrs x0, nzcv
    brk #0
""")
    
    # ========== 寄存器重叠测试 ==========
    
    gen_test("reg_overlap_add", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000004"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    add x0, x0, x0
    add x0, x0, x0
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
    mul x0, x0, x0
    mul x0, x0, x0
    brk #0
""")
    
    print(f"Generated {len(os.listdir(TEST_DIR))} test files in {TEST_DIR}")

if __name__ == "__main__":
    main()
