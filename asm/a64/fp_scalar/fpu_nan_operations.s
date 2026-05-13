/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0xFFFFFFFFFFFFFFFF" },
  "VecData": {}
}
*/
.text
.global _start
_start:
    // NaN + 任何值 = NaN
    mov w8, #0x7FC0         // 单精度 quiet NaN
    fmov s0, w8
    fmov s1, #1.0
    fadd s2, s0, s1
    
    fmov w0, s2
    // 检查结果是否为 NaN
    lsr w1, w0, #23
    cmp w1, #0xFF
    b.ne fail
    and w1, w0, #0x7FFFFF
    cmp w1, #0
    b.eq fail
    
    // NaN - 任何值 = NaN
    fsub s2, s0, s1
    fmov w0, s2
    lsr w1, w0, #23
    cmp w1, #0xFF
    b.ne fail
    and w1, w0, #0x7FFFFF
    cmp w1, #0
    b.eq fail
    
    // NaN * 任何值 = NaN
    fmul s2, s0, s1
    fmov w0, s2
    lsr w1, w0, #23
    cmp w1, #0xFF
    b.ne fail
    and w1, w0, #0x7FFFFF
    cmp w1, #0
    b.eq fail
    
    // NaN / 任何值 = NaN
    fdiv s2, s0, s1
    fmov w0, s2
    lsr w1, w0, #23
    cmp w1, #0xFF
    b.ne fail
    and w1, w0, #0x7FFFFF
    cmp w1, #0
    b.eq fail
    
    mov x0, #0
    brk #0

fail:
    mov x0, #0xFFFFFFFFFFFFFFFF
    brk #0
