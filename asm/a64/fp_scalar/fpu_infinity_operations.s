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
    // +∞ + +∞ = +∞
    mov w8, #0x7F80         // +∞ 单精度
    fmov s0, w8
    fadd s1, s0, s0
    fmov w0, s1
    mov w9, #0x7F80
    cmp w0, w9
    b.ne fail
    
    // +∞ - +∞ = NaN
    fsub s1, s0, s0
    fmov w0, s1
    lsr w1, w0, #23
    cmp w1, #0xFF
    b.ne fail
    and w1, w0, #0x7FFFFF
    cmp w1, #0
    b.eq fail
    
    // +∞ * +∞ = +∞
    fmul s1, s0, s0
    fmov w0, s1
    cmp w0, w9
    b.ne fail
    
    // +∞ / +∞ = NaN
    fdiv s1, s0, s0
    fmov w0, s1
    lsr w1, w0, #23
    cmp w1, #0xFF
    b.ne fail
    
    // -∞ 测试
    mov w8, #0xFF80         // -∞ 单精度
    fmov s0, w8
    
    // -∞ + -∞ = -∞
    fadd s1, s0, s0
    fmov w0, s1
    mov w9, #0xFF80
    cmp w0, w9
    b.ne fail
    
    // -∞ - -∞ = NaN
    fsub s1, s0, s0
    fmov w0, s1
    lsr w1, w0, #23
    cmp w1, #0xFF
    b.ne fail
    
    // +∞ + -∞ = NaN
    mov w8, #0x7F80         // +∞
    fmov s0, w8
    mov w8, #0xFF80         // -∞
    fmov s1, w8
    fadd s2, s0, s1
    fmov w0, s2
    lsr w1, w0, #23
    cmp w1, #0xFF
    b.ne fail
    
    mov x0, #0
    brk #0

fail:
    mov x0, #0xFFFFFFFFFFFFFFFF
    brk #0
