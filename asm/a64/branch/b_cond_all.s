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
    // 测试 EQ 条件码
    
    mov x0, #0
    
    // 比较 0 和 0，设置 Z=1
    cmp xzr, xzr
    
    // EQ: Z=1 时跳转
    b.eq eq_taken
    b done
    
eq_taken:
    mov x0, #1
    
done:
    brk #0