#!/usr/bin/env python3
"""
Generate comprehensive A64 tests covering ALL instruction categories.
Fixed version with correct syntax.
"""
import os
from pathlib import Path
import json

TEST_DIR = str(Path(__file__).resolve().parent / "a64_all")

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
    
    # ========== 整数算术 ==========
    
    # ADD 立即数
    gen_test("add_imm", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    add x0, x0, #0x1000
    brk #0
""")
    
    # ADD 寄存器
    gen_test("add_reg", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000003"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    mov x1, #2
    add x0, x0, x1
    brk #0
""")
    
    # ADD 移位变体
    gen_test("add_lsl", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000005"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    add x0, x0, x1, lsl #2
    brk #0
""")
    
    gen_test("add_lsr", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000003"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    mov x1, #0x10
    add x0, x0, x1, lsr #2
    brk #0
""")
    
    # ADD 扩展寄存器 - 正确语法
    gen_test("add_ext_sxtw", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFF80"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov w1, #0x80
    add x0, x0, w1, sxtw
    brk #0
""")
    
    gen_test("add_ext_sxtb", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFF80"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov w1, #0x80
    add x0, x0, w1, sxtb
    brk #0
""")
    
    gen_test("add_ext_sxth", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFF80"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov w1, #0x80
    add x0, x0, w1, sxth
    brk #0
""")
    
    gen_test("add_ext_uxtw", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000080"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov w1, #0x80
    add x0, x0, w1, uxtw
    brk #0
""")
    
    # SUB
    gen_test("sub_imm", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFF8"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    sub x0, x0, #8
    brk #0
""")
    
    gen_test("sub_reg", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000003"}
    }, """
.text
.global _start
_start:
    mov x0, #5
    mov x1, #2
    sub x0, x0, x1
    brk #0
""")
    
    # ADDS/SUBS 标志位测试
    gen_test("adds_z_flag", {
        "Match": "All",
        "RegData": {"X0": "0x0000000040000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    adds x0, x0, #0
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("adds_n_flag", {
        "Match": "All",
        "RegData": {"X0": "0x0000000080000000"}
    }, """
.text
.global _start
_start:
    mov x0, #-1
    adds x0, x0, #0
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("adds_c_flag", {
        "Match": "All",
        "RegData": {"X0": "0x0000000020000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFFFFFFFFFFFFFFFF
    adds x0, x0, #1
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("adds_v_flag", {
        "Match": "All",
        "RegData": {"X0": "0x0000000010000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0x7FFFFFFFFFFFFFFF
    adds x0, x0, #1
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("subs_zc_flags", {
        "Match": "All",
        "RegData": {"X0": "0x0000000060000000"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    subs x0, x0, #1
    mrs x0, nzcv
    brk #0
""")
    
    # ADC/ADCS/SBC/SBCS
    gen_test("adc_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000002"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    subs xzr, x1, #0
    adc x0, x0, xzr
    brk #0
""")
    
    gen_test("sbc_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000002"}
    }, """
.text
.global _start
_start:
    mov x0, #5
    mov x1, #3
    subs xzr, x0, x0
    sbc x0, x0, x1
    brk #0
""")
    
    # ========== 逻辑运算 ==========
    
    for op, exp, v1, v2 in [
        ("and", "0x00000000000000F0", "0xFF", "0xF0"),
        ("orr", "0x00000000000000FF", "0xF0", "0x0F"),
        ("eor", "0x00000000000000FF", "0xF0", "0x0F"),
        ("bic", "0x000000000000000F", "0xFF", "0xF0"),
        ("orn", "0xFFFFFFFFFFFFFFF0", "0x00", "0x0F"),
        ("eon", "0xFFFFFFFFFFFFFF0F", "0xF0", "0x0F"),
    ]:
        gen_test(f"{op}_reg", {
            "Match": "All",
            "RegData": {"X0": exp}
        }, f"""
.text
.global _start
_start:
    mov x0, #{v1}
    mov x1, #{v2}
    {op} x0, x0, x1
    brk #0
""")
    
    gen_test("ands_z_flag", {
        "Match": "All",
        "RegData": {"X0": "0x0000000040000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF
    ands x0, x0, #0
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("ands_n_flag", {
        "Match": "All",
        "RegData": {"X0": "0x0000000080000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0x8000000000000000
    ands x0, x0, x0
    mrs x0, nzcv
    brk #0
""")
    
    # ========== 移位指令 ==========
    
    gen_test("lsl_imm", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000010"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    lsl x0, x0, #4
    brk #0
""")
    
    gen_test("lsr_imm", {
        "Match": "All",
        "RegData": {"X0": "0x000000000000000F"}
    }, """
.text
.global _start
_start:
    mov x0, #0xF0
    lsr x0, x0, #4
    brk #0
""")
    
    gen_test("asr_imm", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFF8"}
    }, """
.text
.global _start
_start:
    mov x0, #0x8000000000000000
    asr x0, x0, #60
    brk #0
""")
    
    gen_test("ror_imm", {
        "Match": "All",
        "RegData": {"X0": "0xF000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0xF
    ror x0, x0, #4
    brk #0
""")
    
    gen_test("lsl_reg", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000010"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    mov x1, #4
    lsl x0, x0, x1
    brk #0
""")
    
    gen_test("lsr_reg", {
        "Match": "All",
        "RegData": {"X0": "0x000000000000000F"}
    }, """
.text
.global _start
_start:
    mov x0, #0xF0
    mov x1, #4
    lsr x0, x0, x1
    brk #0
""")
    
    gen_test("asr_reg", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFF8"}
    }, """
.text
.global _start
_start:
    mov x0, #0x8000000000000000
    mov x1, #60
    asr x0, x0, x1
    brk #0
""")
    
    gen_test("ror_reg", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000F0"}
    }, """
.text
.global _start
_start:
    mov x0, #0xF
    mov x1, #60
    ror x0, x0, x1
    brk #0
""")
    
    # 移位边界测试
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
    
    # ========== 位操作指令 ==========
    
    for lsb in [0, 8, 16, 24, 32, 48, 56]:
        gen_test(f"bfi_lsb{lsb}", {
            "Match": "All",
            "RegData": {"X1": hex(0xFF << lsb)}
        }, f"""
.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    bfi x1, x0, #{lsb}, #8
    brk #0
""")
    
    gen_test("ubfx_basic", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000FF"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF00
    ubfx x0, x0, #8, #8
    brk #0
""")
    
    gen_test("sbfx_sign", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFF8"}
    }, """
.text
.global _start
_start:
    mov x0, #0x78
    sbfx x0, x0, #3, #4
    brk #0
""")
    
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
    
    # ========== 乘法指令 ==========
    
    gen_test("mul_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000006"}
    }, """
.text
.global _start
_start:
    mov x0, #2
    mov x1, #3
    mul x0, x0, x1
    brk #0
""")
    
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
    madd x0, x1, x2, x0
    brk #0
""")
    
    gen_test("msub_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFB"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    mov x1, #2
    mov x2, #3
    msub x0, x1, x2, x0
    brk #0
""")
    
    gen_test("smull_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    mov w1, #0xFFFF
    mov w2, #1
    smull x0, w1, w2
    brk #0
""")
    
    gen_test("umull_basic", {
        "Match": "All",
        "RegData": {"X0": "0x00000000FFFFFFFE"}
    }, """
.text
.global _start
_start:
    mov w1, #0xFFFFFFFE
    mov w2, #1
    umull x0, w1, w2
    brk #0
""")
    
    gen_test("umulh_basic", {
        "Match": "All",
        "RegData": {"X0": "0x00000000FFFFFFFE"}
    }, """
.text
.global _start
_start:
    mov x1, #0xFFFFFFFF
    mov x2, #0xFFFFFFFF
    umulh x0, x1, x2
    brk #0
""")
    
    gen_test("mneg_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFA"}
    }, """
.text
.global _start
_start:
    mov x1, #2
    mov x2, #3
    mneg x0, x1, x2
    brk #0
""")
    
    # ========== 除法指令 ==========
    
    gen_test("sdiv_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000004"}
    }, """
.text
.global _start
_start:
    mov x0, #12
    mov x1, #3
    sdiv x0, x0, x1
    brk #0
""")
    
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
    
    gen_test("udiv_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000004"}
    }, """
.text
.global _start
_start:
    mov x0, #12
    mov x1, #3
    udiv x0, x0, x1
    brk #0
""")
    
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
    
    # ========== 条件选择指令 ==========
    
    conditions = [
        ("eq", "0xAA"), ("ne", "0xBB"), ("cs", "0xAA"), ("cc", "0xBB"),
        ("mi", "0xBB"), ("pl", "0xAA"), ("vs", "0xBB"), ("vc", "0xAA"),
        ("hi", "0xBB"), ("ls", "0xAA"), ("ge", "0xAA"), ("lt", "0xBB"),
        ("gt", "0xBB"), ("le", "0xAA"),
    ]
    
    for cond, exp in conditions:
        gen_test(f"csel_{cond}", {
            "Match": "All",
            "RegData": {"X0": f"0x000000000000{exp}"}
        }, f"""
.text
.global _start
_start:
    mov x0, #0xAA
    mov x1, #0xBB
    cmp xzr, xzr
    csel x0, x0, x1, {cond}
    brk #0
""")
    
    gen_test("csinc_eq", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000AA"}
    }, """
.text
.global _start
_start:
    mov x0, #0xAA
    cmp xzr, xzr
    csinc x0, x0, xzr, eq
    brk #0
""")
    
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
    
    gen_test("cinc_eq", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000002"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    cmp xzr, xzr
    cinc x0, x0, eq
    brk #0
""")
    
    gen_test("cinv_eq", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFE"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    cmp xzr, xzr
    cinv x0, x0, eq
    brk #0
""")
    
    # ========== 比较指令 ==========
    
    gen_test("cmp_eq", {
        "Match": "All",
        "RegData": {"X0": "0x0000000060000000"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    cmp x0, #1
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("cmn_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000060000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    cmn x0, #0
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("ccmp_taken", {
        "Match": "All",
        "RegData": {"X0": "0x0000000060000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    cmp x0, #0
    ccmp x0, #0, #0x0, eq
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("ccmp_not_taken", {
        "Match": "All",
        "RegData": {"X0": "0x00000000F0000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    cmp x0, #1
    ccmp x0, #0, #0xF, eq
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("ccmn_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000060000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    cmp x0, #0
    ccmn x0, #0, #0x0, eq
    mrs x0, nzcv
    brk #0
""")
    
    # ========== 分支指令 ==========
    
    gen_test("b_eq", {
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
    
    gen_test("tbz_taken", {
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
    
    gen_test("tbnz_taken", {
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
    
    # ========== 特殊指令 ==========
    
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
    
    gen_test("cls_basic", {
        "Match": "All",
        "RegData": {"X0": "0x000000000000003E"}
    }, """
.text
.global _start
_start:
    mov x0, #2
    cls x0, x0
    brk #0
""")
    
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
    
    gen_test("rev16_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000341200785600"}
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
    
    # ========== 浮点指令 ==========
    
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
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("fcmp_gt", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.0
    fmov d1, #1.0
    fcmp d0, d1
    mrs x0, nzcv
    brk #0
""")
    
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
    
    gen_test("fcvtas_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000003"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.5
    fcvtas x0, d0
    brk #0
""")
    
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
    
    for mode, exp in [("m", "0x4000000000000000"), ("p", "0x4008000000000000"), 
                       ("z", "0x4000000000000000"), ("n", "0x4000000000000000"),
                       ("x", "0x4000000000000000")]:
        gen_test(f"frint{mode}_basic", {
            "Match": "All",
            "RegData": {"X0": exp}
        }, f"""
.text
.global _start
_start:
    fmov d0, #2.5
    frint{mode} d0, d0
    fmov x0, d0
    brk #0
""")
    
    gen_test("fmov_imm", {
        "Match": "All",
        "RegData": {"X0": "0x3FF0000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov x0, d0
    brk #0
""")
    
    # ========== 向量指令 ==========
    
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
    
    gen_test("vand_16b", {
        "Match": "All",
        "RegData": {"X0": "0xF0F0F0F0F0F0F0F0"}
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
    
    gen_test("vmla_4s", {
        "Match": "All",
        "RegData": {"X0": "0x0000000700000007"}
    }, """
.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    movi v2.4s, #3
    mla v0.4s, v1.4s, v2.4s
    mov x0, v0.d[0]
    brk #0
""")
    
    gen_test("vmls_4s", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFF9"}
    }, """
.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    movi v2.4s, #3
    mls v0.4s, v1.4s, v2.4s
    mov x0, v0.d[0]
    brk #0
""")
    
    # ========== 内存指令 ==========
    
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
    
    gen_test("ldrb_strb_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000034"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #16
    mov x0, #0x1234
    strb w0, [sp]
    mov x0, #0
    ldrb w0, [sp]
    add sp, sp, #16
    brk #0
""")
    
    gen_test("ldrh_strh_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001234"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #16
    mov x0, #0x1234
    strh w0, [sp]
    mov x0, #0
    ldrh w0, [sp]
    add sp, sp, #16
    brk #0
""")
    
    gen_test("ldrsw_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #16
    mov x0, #0xFFFFFFFF
    str w0, [sp]
    mov x0, #0
    ldrsw x0, [sp]
    add sp, sp, #16
    brk #0
""")
    
    gen_test("stxr_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #16
    mov x1, #0x1234
    ldxr x2, [sp]
    stxr w0, x1, [sp]
    add sp, sp, #16
    brk #0
""")
    
    # ========== 系统指令 ==========
    
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
    
    gen_test("nop_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    nop
    brk #0
""")
    
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
    
    gen_test("reg_overlap_sub", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #5
    sub x0, x0, x0
    brk #0
""")
    
    print(f"Generated {len(os.listdir(TEST_DIR))} test files in {TEST_DIR}")

if __name__ == "__main__":
    main()
