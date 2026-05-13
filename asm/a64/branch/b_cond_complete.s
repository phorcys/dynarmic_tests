/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000002" },
  "VecData": {}
}
*/
.text
.global _start
_start:
    // 测试 EQ 和 NE 条件码
    
    mov x0, #0
    
    // EQ: Z=1 时跳转 (相等)
    cmp xzr, xzr              // 比较 0 == 0, Z=1
    b.eq eq_taken
    b done
    
eq_taken:
    add x0, x0, #1            // x0 = 1
    
    // NE: Z=0 时跳转 (不相等)
    mov x1, #5
    mov x2, #10
    cmp x1, x2                // 比较 5 != 10, Z=0
    b.ne ne_taken
    b done
    
ne_taken:
    add x0, x0, #1            // x0 = 2
    
    brk #0
    
done:
    brk #0
