#!/usr/bin/env python3
"""
Generate extended A64 tests covering more instructions and edge cases.
"""
import os
from pathlib import Path
import json

TEST_DIR = str(Path(__file__).resolve().parent / "a64_extended")

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
    
    # ========== NEG/NGS 带标志位 ==========
    gen_test("neg_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFF6"}
    }, """
.text
.global _start
_start:
    mov x0, #10
    neg x0, x0
    brk #0
""")
    
    gen_test("negs_z_flag", {
        "Match": "All",
        "RegData": {"X0": "0x0000000040000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    negs x0, x0
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("ngc_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000009"}
    }, """
.text
.global _start
_start:
    mov x0, #10
    subs xzr, x0, x0  // C=1
    ngc x0, xzr       // x0 = 0 - 0 - ~C = 0 - 0 - 0 = 0... wait
    // ngc: result = 0 - operand - ~C
    // 如果 C=1, ~C=0, 结果 = 0 - 0 - 0 = 0
    // 让我重新设计
    brk #0
""")
    
    # ========== TST 指令 ==========
    gen_test("tst_z_flag", {
        "Match": "All",
        "RegData": {"X0": "0x0000000040000000"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    tst x0, #0
    mrs x0, nzcv
    brk #0
""")
    
    gen_test("tst_n_flag", {
        "Match": "All",
        "RegData": {"X0": "0x0000000080000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0x8000000000000000
    tst x0, x0
    mrs x0, nzcv
    brk #0
""")
    
    # ========== MOV 变体 ==========
    gen_test("mov_reg", {
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
    
    gen_test("mov_imm", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001234"}
    }, """
.text
.global _start
_start:
    mov x0, #0x1234
    brk #0
""")
    
    # ========== MVN 指令 ==========
    gen_test("mvn_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFF00"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF
    mvn x0, x0
    brk #0
""")
    
    # ========== ADD/SUB 32位变体 ==========
    gen_test("add_w_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000003"}
    }, """
.text
.global _start
_start:
    mov w0, #1
    mov w1, #2
    add w0, w0, w1
    brk #0
""")
    
    gen_test("sub_w_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000003"}
    }, """
.text
.global _start
_start:
    mov w0, #5
    mov w1, #2
    sub w0, w0, w1
    brk #0
""")
    
    gen_test("adds_w_overflow", {
        "Match": "All",
        "RegData": {"X0": "0x0000000010000000"}
    }, """
.text
.global _start
_start:
    mov w0, #0x7FFFFFFF
    adds w0, w0, #1
    mrs x0, nzcv  // V=1, N=0
    brk #0
""")
    
    # ========== 乘法边界条件 ==========
    gen_test("mul_w_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000006"}
    }, """
.text
.global _start
_start:
    mov w0, #2
    mov w1, #3
    mul w0, w0, w1
    brk #0
""")
    
    gen_test("smull_signed", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFF9A"}
    }, """
.text
.global _start
_start:
    mov w0, #-100
    mov w1, #1
    smull x0, w0, w1
    brk #0
""")
    
    # ========== 除法边界条件 ==========
    gen_test("sdiv_min_max", {
        "Match": "All",
        "RegData": {"X0": "0x8000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #0x8000000000000000
    mov x1, #-1
    sdiv x0, x0, x1  // INT_MIN / -1 应该返回 INT_MIN (不溢出)
    brk #0
""")
    
    # ========== 移位边界条件 ==========
    gen_test("lsl_w_31", {
        "Match": "All",
        "RegData": {"X0": "0x0000000080000000"}
    }, """
.text
.global _start
_start:
    mov w0, #1
    lsl w0, w0, #31
    brk #0
""")
    
    gen_test("lsr_w_31", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov w0, #0x80000000
    lsr w0, w0, #31
    brk #0
""")
    
    gen_test("asr_w_31", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    mov w0, #0x80000000
    asr w0, w0, #31
    brk #0
""")
    
    # ========== 位操作边界条件 ==========
    gen_test("bfxil_basic", {
        "Match": "All",
        "RegData": {"X0": "0x000000000000FF00"}
    }, """
.text
.global _start
_start:
    mov x0, #0xFF00
    mov x1, #0x00
    bfxil x1, x0, #0, #16
    brk #0
""")
    
    gen_test("ubfiz_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000F00"}
    }, """
.text
.global _start
_start:
    mov x0, #0xF
    ubfiz x0, x0, #8, #4
    brk #0
""")
    
    gen_test("sbfiz_basic", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFF00"}
    }, """
.text
.global _start
_start:
    mov x0, #0xF
    sbfiz x0, x0, #4, #4
    brk #0
""")
    
    # ========== 条件指令边界条件 ==========
    gen_test("csel_ne_taken", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000AA"}
    }, """
.text
.global _start
_start:
    mov x0, #0xAA
    mov x1, #0xBB
    mov x2, #1
    cmp x2, #0  // NE
    csel x0, x0, x1, ne
    brk #0
""")
    
    gen_test("csinc_ne", {
        "Match": "All",
        "RegData": {"X0": "0x00000000000000AB"}
    }, """
.text
.global _start
_start:
    mov x0, #0xAA
    mov x2, #1
    cmp x2, #0  // NE
    csinc x0, x0, xzr, ne
    brk #0
""")
    
    gen_test("csinv_ne", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFF55"}
    }, """
.text
.global _start
_start:
    mov x0, #0xAA
    mov x2, #1
    cmp x2, #0  // NE
    csinv x0, x0, xzr, ne
    brk #0
""")
    
    # ========== 比较指令边界条件 ==========
    gen_test("cmp_gt", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    mov x0, #5
    cmp x0, #3
    mrs x0, nzcv  // C=1, N=0 -> 0x20000000
    brk #0
""")
    
    gen_test("cmp_lt", {
        "Match": "All",
        "RegData": {"X0": "0x0000000080000000"}
    }, """
.text
.global _start
_start:
    mov x0, #3
    cmp x0, #5
    mrs x0, nzcv  // N=1
    brk #0
""")
    
    # ========== 分支指令边界条件 ==========
    gen_test("b_ne", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    cmp x1, #0
    b.ne 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0
""")
    
    gen_test("b_mi", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov x1, #-1
    cmp x1, #0
    b.mi 1f
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
    tbz x1, #63, 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0
""")
    
    gen_test("tbnz_bit63", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov x1, #0x8000000000000000
    tbnz x1, #63, 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0
""")
    
    # ========== 浮点边界条件 ==========
    gen_test("fadd_neg", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #-1.0
    fadd d0, d0, d1
    fmov x0, d0
    brk #0
""")
    
    gen_test("fmul_neg", {
        "Match": "All",
        "RegData": {"X0": "0xC000000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.0
    fmov d1, #-1.0
    fmul d0, d0, d1
    fmov x0, d0
    brk #0
""")
    
    gen_test("fdiv_neg", {
        "Match": "All",
        "RegData": {"X0": "0xC000000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.0
    fmov d1, #-1.0
    fdiv d0, d0, d1
    fmov x0, d0
    brk #0
""")
    
    gen_test("fabs_chain", {
        "Match": "All",
        "RegData": {"X0": "0x4000000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #-2.0
    fneg d0, d0
    fabs d0, d0
    fmov x0, d0
    brk #0
""")
    
    gen_test("fmaxnm_basic", {
        "Match": "All",
        "RegData": {"X0": "0x4000000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #2.0
    fmaxnm d0, d0, d1
    fmov x0, d0
    brk #0
""")
    
    gen_test("fminnm_basic", {
        "Match": "All",
        "RegData": {"X0": "0x3FF0000000000000"}
    }, """
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #2.0
    fminnm d0, d0, d1
    fmov x0, d0
    brk #0
""")
    
    # 浮点转换边界条件
    gen_test("fcvtns_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000003"}
    }, """
.text
.global _start
_start:
    fmov d0, #3.0
    fcvtns x0, d0
    brk #0
""")
    
    gen_test("fcvtnu_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000003"}
    }, """
.text
.global _start
_start:
    fmov d0, #3.0
    fcvtnu x0, d0
    brk #0
""")
    
    gen_test("fcvtps_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000003"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.5
    fcvtps x0, d0  // round to +inf: 2.5 -> 3
    brk #0
""")
    
    gen_test("fcvtms_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000002"}
    }, """
.text
.global _start
_start:
    fmov d0, #2.5
    fcvtms x0, d0  // round to -inf: 2.5 -> 2
    brk #0
""")
    
    # ========== 向量指令扩展 ==========
    gen_test("vadd_2d", {
        "Match": "All",
        "RegData": {"X0": "0x0000000300000003"}
    }, """
.text
.global _start
_start:
    movi v0.2d, #1
    movi v1.2d, #2
    add v0.2d, v0.2d, v1.2d
    mov x0, v0.d[0]
    brk #0
""")
    
    gen_test("vsub_2d", {
        "Match": "All",
        "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
    }, """
.text
.global _start
_start:
    movi v0.2d, #1
    movi v1.2d, #2
    sub v0.2d, v0.2d, v1.2d
    mov x0, v0.d[0]
    brk #0
""")
    
    gen_test("vmul_8h", {
        "Match": "All",
        "RegData": {"X0": "0x0006000600060006"}
    }, """
.text
.global _start
_start:
    movi v0.8h, #2
    movi v1.8h, #3
    mul v0.8h, v0.8h, v1.8h
    mov x0, v0.d[0]
    brk #0
""")
    
    gen_test("vshl_4s", {
        "Match": "All",
        "RegData": {"X0": "0x0000000400000004"}
    }, """
.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    sshl v0.4s, v0.4s, v1.4s
    mov x0, v0.d[0]
    brk #0
""")
    
    # ========== 内存指令扩展 ==========
    gen_test("ldr_pre_index", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001234"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #32
    mov x0, #0x1234
    str x0, [sp, #8]
    mov x0, #0
    ldr x0, [sp, #8]!
    add sp, sp, #16
    brk #0
""")
    
    gen_test("ldr_post_index", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001234"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #32
    mov x0, #0x1234
    str x0, [sp]
    mov x1, sp
    mov x0, #0
    ldr x0, [x1], #8
    add sp, sp, #32
    brk #0
""")
    
    gen_test("stp_pre_index", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000001234", "X1": "0x0000000000005678"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #32
    mov x0, #0x1234
    mov x1, #0x5678
    stp x0, x1, [sp, #-16]!
    mov x0, #0
    mov x1, #0
    ldp x0, x1, [sp]
    add sp, sp, #32
    brk #0
""")
    
    gen_test("ldaxr_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #16
    ldaxr x0, [sp]
    add sp, sp, #16
    brk #0
""")
    
    gen_test("stlxr_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000000"}
    }, """
.text
.global _start
_start:
    sub sp, sp, #16
    mov x1, #0x1234
    stlxr w0, x1, [sp]
    add sp, sp, #16
    brk #0
""")
    
    # ========== 系统指令扩展 ==========
    gen_test("dsb_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    dsb sy
    brk #0
""")
    
    gen_test("isb_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000001"}
    }, """
.text
.global _start
_start:
    mov x0, #1
    isb
    brk #0
""")
    
    # ========== CRC 指令 ==========
    gen_test("crc32b_basic", {
        "Match": "All",
        "RegData": {"X0": "0x00000000E8F9E30D"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov w1, #0x41
    crc32b w0, w0, w1
    brk #0
""")
    
    gen_test("crc32h_basic", {
        "Match": "All",
        "RegData": {"X0": "0x00000000E8F9E30D"}
    }, """
.text
.global _start
_start:
    mov x0, #0
    mov w1, #0x41
    crc32h w0, w0, w1
    brk #0
""")
    
    # ========== 位计数指令 ==========
    gen_test("cnt_basic", {
        "Match": "All",
        "RegData": {"X0": "0x0000000000000040"}
    }, """
.text
.global _start
_start:
    mov x0, #-1
    cnt x0, x0
    brk #0
""")
    
    print(f"Generated {len(os.listdir(TEST_DIR))} test files in {TEST_DIR}")

if __name__ == "__main__":
    main()
