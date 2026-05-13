/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000000" },
  "VecData": {}
}
*/
.text
.global _start
_start:
    // 非规格化数测试
    
    // 1. 非规格化 + 非规格化
    mov w8, #1
    fmov s0, w8
    fadd s1, s0, s0
    fmov w0, s1
    cmp w0, #2
    b.ne fail
    
    // 2. 非规格化 / 1.0 = 非规格化
    mov w8, #1
    fmov s0, w8
    fmov s1, #1.0
    fdiv s2, s0, s1
    fmov w0, s2
    cmp w0, #1
    b.ne fail
    
    mov x0, #0
    brk #0

fail:
    mov x0, #0xFFFFFFFFFFFFFFFF
    brk #0