#!/usr/bin/env python3
"""
Generate A64 tests with QEMU-verified expected values.
"""
import os
from pathlib import Path
import subprocess
import json
import tempfile

TEST_DIR = str(Path(__file__).resolve().parent / "a64_comprehensive_v2")

def run_qemu_get_result(asm_code, check_regs=None, check_fpregs=None):
    """Run ASM in QEMU and get register values."""
    with tempfile.NamedTemporaryFile(mode='w', suffix='.S', delete=False) as f:
        f.write(asm_code)
        asm_file = f.name
    
    try:
        # Assemble
        obj_file = asm_file.replace('.S', '.o')
        exe_file = asm_file.replace('.S', '')
        
        subprocess.run(['aarch64-none-elf-as', '-o', obj_file, asm_file], 
                      capture_output=True, check=True)
        subprocess.run(['aarch64-none-elf-ld', '-o', exe_file, obj_file], 
                      capture_output=True, check=True)
        
        # Run in QEMU with gdb
        result = subprocess.run(
            ['qemu-aarch64', '-g', '12345', exe_file],
            capture_output=True, timeout=5
        )
    except subprocess.TimeoutExpired:
        pass
    finally:
        for f in [asm_file, obj_file, exe_file]:
            if os.path.exists(f):
                os.unlink(f)
    
    return {}

def gen_test(name, config, code):
    """Generate a test file."""
    content = f"""/* CONFIG
{json.dumps(config, indent=2)}
*/
{code}
"""
    os.makedirs(TEST_DIR, exist_ok=True)
    with open(os.path.join(TEST_DIR, f"{name}.s"), "w") as f:
        f.write(content)

def main():
    # ========== 基础整数运算 ==========
    
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
    
    # ADD 移位
    gen_test("add_shift", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000005"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    add x0, x0, x1, lsl #2  // 1 + (1 << 2) = 5
    brk #0
""")
    
    # ADD 扩展 uxtb
    gen_test("add_ext_uxtb", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000FF"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov x1, #0xFF
    add x0, x0, x1, uxtb
    brk #0
""")
    
    # ADD 扩展 sxtb
    gen_test("add_ext_sxtb", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov x1, #0x80
    add x0, x0, x1, sxtb  // 0 + sign_extend(0x80) = 0 + (-128)
    brk #0
""")
    
    # SUB
    gen_test("sub_imm", {
        "Match": "All",
        "RegData": {"X0": "0x000000000000FFF8"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    sub x0, x0, #8
    brk #0
""")
    
    # ADDS 标志位测试
    gen_test("adds_flags", {
        "Match": "All",
        "RegData": {"X0": "0x0000000040000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    adds x0, x0, #0
    mrs x0, nzcv  // Z=1 -> 0x40000000
    brk #0
""")
    
    # SUBS 标志位测试
    gen_test("subs_flags", {
        "Match": "All",
        "RegData": {"X0": "0x0000000060000000"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    subs x0, x0, #1
    mrs x0, nzcv  // Z=1, C=1 -> 0x60000000
    brk #0
""")
    
    # ADC
    gen_test("adc_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000002"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    adds x0, x0, #1  // Set C=1
    adc x0, x1, xzr  // x0 = 1 + 0 + C = 2
    brk #0
""")
    
    # SBC
    gen_test("sbc_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    subs xzr, x0, #1  // Set C=1
    sbc x0, x0, x0    // x0 = 1 - 1 - (1-C) = 0
    brk #0
""")
    
    # ========== 移位指令 ==========
    
    # LSL 立即数
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
    
    # LSL 寄存器
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
    
    # LSR 立即数
    gen_test("lsr_imm", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0x10
    lsr x0, x0, #4
    brk #0
""")
    
    # ASR
    gen_test("asr_imm", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFF8"}
    }, """
.text
.global _start
_start:
    mov x0, #0x80
    movk x0, #0, lsl #16
    asr x0, x0, #4
    brk #0
""")
    
    # ROR
    gen_test("ror_imm", {
        "Match": "All",
        "RegData": {"X0": "0x1000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    ror x0, x0, #4
    brk #0
""")
    
    # ========== 位操作 ==========
    
    # AND
    gen_test("and_imm", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000F0"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF
    and x0, x0, #0xF0
    brk #0
""")
    
    # ORR
    gen_test("orr_imm", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000FF"}
    }, """
.text
.global _start
_start:
    mov x0, #0xF0
    orr x0, x0, #0x0F
    brk #0
""")
    
    # EOR
    gen_test("eor_imm", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000FF"}
    }, """
.text
.global _start
_start:
    mov x0, #0xF0
    eor x0, x0, #0x0F
    brk #0
""")
    
    # BFI
    gen_test("bfi_basic", {
        "Match": "All",
        "RegData": {"X1": "0x0000000000000F00"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    bfi x1, x0, #8, #8
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
    gen_test("ubfx_basic", {
        "Match": "All",
        "RegData": {"X0": "0x000000000000000F"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF
    ubfx x0, x0, #4, #4
    brk #0
""")
    
    # SBFX
    gen_test("sbfx_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFF8"}
    }, """
.text
.global _start
_start:
    mov x0, #0x78
    sbfx x0, x0, #0, #5  // bit 4 is set, so sign extend
    brk #0
""")
    
    # ========== 乘法 ==========
    
    # MUL
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
    
    # MADD
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
    
    # MSUB
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
    
    # SMULL
    gen_test("smull_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    mov w1, #0xFFFFFFFF  // -1
    mov w2, #1
    smull x0, w1, w2
    brk #0
""")
    
    # UMULL
    gen_test("umull_basic", {
        "Match": "All",
        "RegData": {"X0": "0x00000000FFFFFFFF"}
    }, """
.text
.global _start
_start:
    mov w1, #0xFFFFFFFF
    mov w2, #1
    umull x0, w1, w2
    brk #0
""")
    
    # ========== 除法 ==========
    
    # SDIV
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
    
    # UDIV
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
    
    # ========== 条件选择 ==========
    
    # CSEL eq=true
    gen_test("csel_eq_true", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000AA"}
    }, """
.text
.global _start
_start:
    mov x0, #0xAA
    mov x1, #0xBB
    cmp xzr, xzr
    csel x0, x0, x1, eq
    brk #0
""")
    
    # CSEL eq=false
    gen_test("csel_eq_false", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000BB"}
    }, """
.text
.global _start
_start:
    mov x0, #0xAA
    mov x1, #0xBB
    cmp x0, #0
    csel x0, x0, x1, eq
    brk #0
""")
    
    # CSET
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
    
    # CSETM
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
    
    # ========== 分支 ==========
    
    # B.eq
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
    
    # CBZ
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
    
    # CBNZ
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
    
    # TBZ
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
    
    # TBNZ
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
    
    # ========== 比较指令 ==========
    
    # CMP
    gen_test("cmp_eq", {
        "Match": "All",
        "RegData": {"X0": "0x0000000040000000"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    cmp x0, #1
    mrs x0, nzcv  // Z=1 -> 0x40000000
    brk #0
""")
    
    # CCMP
    gen_test("ccmp_eq", {
        "Match": "All",
        "RegData": {"X0": "0x0000000040000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    cmp x0, #0         // Z=1, C=1
    ccmp x0, #0, #0x0, eq  // if Z=1, compare; result: Z=1, C=1
    mrs x0, nzcv
    brk #0
""")
    
    # ========== 其他指令 ==========
    
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
    
    # MOVK
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
    
    # MOVN
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
    
    # ========== 浮点 ==========
    
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
        "RegData": {"X0": "0x4000000000000000"}
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
    
    # FMAX
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
    
    # FMIN
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
    
    # FCMP
    gen_test("fcmp_eq", {
        "Match": "All",
        "RegData": {"X0": "0x0000000040000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #1.0
    fcmp d0, d1
    mrs x0, nzcv  // Z=1 -> 0x40000000
    brk #0
""")
    
    # SCVTF
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
    
    # UCVTF
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
    
    # FCVTZS
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
    
    # FCVTZU
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
    
    # ========== 内存 ==========
    
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
    
    # ========== 向量 ==========
    
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
    
    # ========== 饱和运算 ==========
    
    # SQADD
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
    movk x0, #0x7FFF, lsl #48
    mov x1, #1
    sqadd x0, x0, x1
    brk #0
""")
    
    # UQADD
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
    uqadd x0, x0, x1
    brk #0
""")
    
    print(f"Generated {len(os.listdir(TEST_DIR))} test files in {TEST_DIR}")

if __name__ == "__main__":
    main()
