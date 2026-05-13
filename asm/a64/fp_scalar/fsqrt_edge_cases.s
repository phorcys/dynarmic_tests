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
    // NaN 的平方根还是 NaN
    mov x8, #0x7FC0         // 单精度 NaN (quiet NaN)
    fmov s0, w8
    fsqrt s1, s0
    
    // 提取结果并验证是 NaN
    fmov w0, s1
    // NaN 检查: 指数全1且尾数非零
    lsr w1, w0, #23         // 提取指数
    cmp w1, #0xFF
    b.ne fail
    // 尾数非零
    and w1, w0, #0x7FFFFF
    cmp w1, #0
    b.eq fail
    
    mov x0, #0
    brk #0

fail:
    mov x0, #0xFFFFFFFFFFFFFFFF
    brk #0
