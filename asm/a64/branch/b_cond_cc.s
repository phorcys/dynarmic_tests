/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000001" },
  "VecData": {}
}
*/
.text
.global _start
_start:
    // 测试 CC (Carry Clear) / LO (Unsigned Lower)
    // CC: C=0 时跳转
    
    mov x0, #0
    
    // 产生借位: 0 - 1 借位，C=0
    // ARM 减法: C = NOT borrow = (a >= b) 无符号
    // 0 < 1, 所以 borrow=1, C=0
    mov x1, #0
    mov x2, #1
    subs x3, x1, x2           // 0 - 1 = -1, C=0 (有借位)
    
    b.cc cc_taken
    b done
    
cc_taken:
    mov x0, #1
    
done:
    brk #0
