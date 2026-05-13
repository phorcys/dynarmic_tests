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
    // 测试 NE 条件码
    // NE: Z=0 时跳转 (不相等)
    
    mov x0, #0
    mov x1, #5
    mov x2, #10
    cmp x1, x2                // 比较 5 != 10, Z=0
    
    b.ne ne_taken
    b done
    
ne_taken:
    mov x0, #1
    
done:
    brk #0