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
    // 测试 CS (Carry Set) / HS (Unsigned Higher or Same)
    // CS: C=1 时跳转
    // ARM: C = NOT borrow = (a >= b) for SUBS
    
    mov x0, #0
    
    // 不产生 C=1: 0 - 1 会设置 C=0 (有借位，borrow=1, C=NOT borrow=0)
    mov x1, #0
    mov x2, #1
    subs x3, x1, x2           // 0 - 1 = -1, borrow=1, C=0
    
    b.cs cs_taken
    b done
    
cs_taken:
    mov x0, #1
    
done:
    brk #0
