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
    // SDIV 除零测试
    // SDIV Xd, Xn, Xm - 如果 Xm == 0，结果为 0
    
    mov x1, #100
    mov x2, #0
    
    sdiv x0, x1, x2      // 100 / 0 = 0
    
    brk #0
