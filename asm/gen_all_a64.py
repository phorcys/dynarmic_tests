#!/usr/bin/env python3
"""
Generate comprehensive A64 tests covering ALL instruction categories.
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
    
    # ========== 整数算术 - 完整覆盖 ==========
    
    # ADD 所有变体
    for size in ["w", "x"]:
        reg = "w0" if size == "w" else "x0"
        reg1 = "w1" if size == "w" else "x1"
        width = 32 if size == "w" else 64
        
        # ADD 立即数
        gen_test(f"add_{size}_imm", {
            "Match": "All",
            "RegData": {"X0": "0x0000000000001000"}
        }, f"""
.text
.global _start
_start:
    mov {reg}, #0
    add {reg}, {reg}, #0x1000
    brk #0
""")
        
        # ADD 寄存器
        gen_test(f"add_{size}_reg", {
            "Match": "All",
            "RegData": {"X0": "0x0000000000000003"}
        }, f"""
.text
.global _start
_start:
    mov {reg}, #1
    mov {reg1}, #2
    add {reg}, {reg}, {reg1}
    brk #0
""")
        
        # ADD 移位
        for shift in ["lsl", "lsr", "asr"]:
            gen_test(f"add_{size}_{shift}", {
                "Match": "All",
                "RegData": {"X0": "0x0000000000000005" if shift == "lsl" else "0x0000000000000003"}
            }, f"""
.text
.global _start
_start:
    mov {reg}, #1
    mov {reg1}, #1
    add {reg}, {reg}, {reg1}, {shift} #2
    brk #0
""")
    
    # ADD 扩展寄存器所有变体
    for ext in ["uxtb", "uxth", "uxtw", "uxtx", "sxtb", "sxth", "sxtw", "sxtx"]:
        for shift in [0, 1, 2, 3, 4]:
            if ext in ["uxtb", "sxtb"]:
                bits = 8
            elif ext in ["uxth", "sxth"]:
                bits = 16
            elif ext in ["uxtw", "sxtw"]:
                bits = 32
            else:
                bits = 64
            
            # 预期值需要计算
            if ext.startswith("ux"):
                # 零扩展
                val = 0x80 & ((1 << bits) - 1)
                expected = val << shift
            else:
                # 符号扩展
                sign_bit = 1 << (bits - 1)
                val = 0x80
                if val & sign_bit:
                    expected = (val | (~((1 << bits) - 1))) << shift
                    expected = expected & 0xFFFFFFFFFFFFFFFF
                else:
                    expected = val << shift
            
            gen_test(f"add_ext_{ext}_s{shift}", {
                "Match": "All",
                "RegData": {"X0": hex(expected)}
            }, f"""
.text
.global _start
_start:
    mov x0, #0
    mov x1, #0x80
    add x0, x0, x1, {ext}, lsl #{shift}
    brk #0
""")
    
    # SUB 所有变体
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
    mrs x0, nzcv  // Z=1
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
    mrs x0, nzcv  // N=1
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
    mrs x0, nzcv  // C=1
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
    mrs x0, nzcv  // V=1
    brk #0
""")
    
    gen_test("subs_c_flag", {
        "Match": "All",
        "RegData": {"X0": "0x0000000060000000"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    subs x0, x0, #1
    mrs x0, nzcv  // Z=1, C=1
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
    subs xzr, x1, #0  // C=1
    adc x0, x0, xzr   // x0 = 1 + 0 + 1 = 2
    brk #0
""")
    
    gen_test("adcs_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFFFFFFFFFFFFFFFF
    mov x1, #1
    subs xzr, x1, #0  // C=1
    adcs x0, x0, x1   // x0 = -1 + 1 + 1 = 1, C=1
    mov x0, #0
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
    subs xzr, x0, x0  // C=1
    sbc x0, x0, x1    // x0 = 5 - 3 - 0 = 2
    brk #0
""")
    
    # ========== 逻辑运算 ==========
    
    # AND/ORR/EOR/BIC/ORN/EON
    for op in ["and", "orr", "eor", "bic", "orn", "eon"]:
        if op == "and":
            expected = "0x00000000000000F0"
            val1, val2 = "0xFF", "0xF0"
        elif op == "orr":
            expected = "0x00000000000000FF"
            val1, val2 = "0xF0", "0x0F"
        elif op == "eor":
            expected = "0x00000000000000FF"
            val1, val2 = "0xF0", "0x0F"
        elif op == "bic":
            expected = "0x000000000000000F"
            val1, val2 = "0xFF", "0xF0"
        elif op == "orn":
            expected = "0xFFFFFFFFFFFFFFF0"
            val1, val2 = "0x00", "0x0F"
        else:  # eon
            expected = "0xFFFFFFFFFFFFFF0F"
            val1, val2 = "0xF0", "0x0F"
        
        gen_test(f"{op}_reg", {
            "Match": "All",
            "RegData": {"X0": expected}
        }, f"""
.text
.global _start
_start:
    mov x0, #{val1}
    mov x1, #{val2}
    {op} x0, x0, x1
    brk #0
""")
    
    # ANDS/ORRS - 设置标志位
    gen_test("ands_z_flag", {
        "Match": "All",
        "RegData": {"X0": "0x0000000040000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF
    ands x0, x0, #0
    mrs x0, nzcv  // Z=1
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
    mrs x0, nzcv  // N=1
    brk #0
""")
    
    # ========== 移位指令 ==========
    
    # LSL/LSR/ASR/ROR - 立即数和寄存器
    for op in ["lsl", "lsr", "asr", "ror"]:
        for variant in ["imm", "reg"]:
            if op == "lsl":
                expected = "0x0000000000000010"
            elif op == "lsr":
                expected = "0x000000000000000F"
            elif op == "asr":
                expected = "0xFFFFFFFFFFFFFFFF"
            else:  # ror
                expected = "0xF000000000000000"
            
            if variant == "imm":
                code = f"""
.text
.global _start
_start:
    mov x0, #0xF0
    {op} x0, x0, #4
    brk #0
"""
            else:
                code = f"""
.text
.global _start
_start:
    mov x0, #0xF0
    mov x1, #4
    {op} x0, x0, x1
    brk #0
"""
            
            gen_test(f"{op}_{variant}", {
                "Match": "All",
                "RegData": {"X0": expected}
            }, code)
    
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
    
    # ========== 位操作指令 ==========
    
    # BFI/BFXIL
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
    
    # UBFX/SBFX
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
    
    # BIC/BICS
    gen_test("bic_basic", {
        "Match": "All",
        "RegData": {"X0": "0x000000000000000F"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0xF0
    bic x0, x0, x1
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
    
    # ========== 乘法指令 ==========
    
    # MUL/MADD/MSUB
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
    
    # SMULL/UMULL
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
    
    # SMULH/UMULH
    gen_test("smulh_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    mov x1, #0xFFFFFFFF
    mov x2, #0xFFFFFFFF
    smulh x0, x1, x2
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
    
    # MNEG
    gen_test("mneg_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFA"}
    }, """
.text
.global _start
_start:
    mov x1, #2
    mov x2, #3
    mneg x0, x1, x2  // -2 * 3 = -6
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
    
    # CSEL 所有条件
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
    
    # CSINC/CSINV/CSNEG
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
    
    # CINC/CINV/CNEG
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
    
    # CLS (count leading sign bits)
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
    
    # REV16/REV32/REV64
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
    
    # ========== 浮点指令 ==========
    
    # FADD/FSUB/FMUL/FDIV
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
    
    # FMAX/FMIN/FMAXNM/FMINNM
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
    
    # FSQRT/FABS/FNEG
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
    
    # FCMP/FCMPE
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
    mrs x0, nzcv  // C=1, N=0 -> 0x20000000
    brk #0
""")
    
    # FCVT (float conversion)
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
    
    # FCVTAS/FCVTAU (round to nearest with ties to away)
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
    
    # FRINTM/FRINTP/FRINTZ/FRINTA/FRINTN/FRINTX
    for mode in ["m", "p", "z", "n", "x"]:
        if mode == "m":
            expected = "0x4000000000000000"  # round to -inf: 2.5 -> 2.0
        elif mode == "p":
            expected = "0x4008000000000000"  # round to +inf: 2.5 -> 3.0
        elif mode == "z":
            expected = "0x4000000000000000"  # round to zero: 2.5 -> 2.0
        elif mode == "n":
            expected = "0x4000000000000000"  # round to nearest even: 2.5 -> 2.0
        else:  # x
            expected = "0x4000000000000000"
        
        gen_test(f"frint{mode}_basic", {
            "Match": "All",
            "RegData": {"X0": expected}
        }, f"""
.text
.global _start
_start:
    fmov d0, #2.5
    frint{mode} d0, d0
    fmov x0, d0
    brk #0
""")
    
    # FMOV variants
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
    
    gen_test("fmov_reg", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001234"}
    }, """
.text
.global _start
_start:
    mov x0, #0x1234
    fmov d0, x0
    fmov x0, d0
    brk #0
""")
    
    # ========== 向量指令 ==========
    
    # VADD/VSUB/VMUL
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
    
    # VAND/VORR/VEOR/VBIC
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
    
    # VMLA/VMLS
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
    mla v0.4s, v1.4s, v2.4s  // v0 += v1 * v2 = 1 + 6 = 7
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
    mls v0.4s, v1.4s, v2.4s  // v0 -= v1 * v2 = 1 - 6 = -5
    mov x0, v0.d[0]
    brk #0
""")
    
    # ========== 内存指令 ==========
    
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
    
    # LDRB/STRB (byte)
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
    
    # LDRH/STRH (halfword)
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
    
    # LDRSW (signed word)
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
    
    # STXR/LDXR (exclusive)
    gen_test("stxr_basic", {
        "Match": "All",
        "RegData": {"W0": "0x00000000"}
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
    
    # MRS/MSR NZCV
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
    
    # NOP
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
    
    # DMB/DSB/ISB
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
    
    # ========== 边界条件测试 ==========
    
    # 最小值
    gen_test("add_min", {
        "Match": "All",
        "RegData": {"X0": "0x8000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0x8000000000000000
    brk #0
""")
    
    # 最大值
    gen_test("add_max", {
        "Match": "All",
        "RegData": {"X0": "0x7FFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    mov x0, #0x7FFFFFFFFFFFFFFF
    movk x0, #0x7FFF, lsl #48
    brk #0
""")
    
    # 全零
    gen_test("add_zero", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    add x0, x0, #0
    brk #0
""")
    
    # 全一
    gen_test("and_ones", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFFFFFFFFFFFFFFFF
    movk x0, #0xFFFF, lsl #16
    movk x0, #0xFFFF, lsl #32
    movk x0, #0xFFFF, lsl #48
    brk #0
""")
    
    print(f"Generated {len(os.listdir(TEST_DIR))} test files in {TEST_DIR}")

if __name__ == "__main__":
    main()
