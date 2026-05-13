/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000020000000" },
  "VecData": {}
}
*/
.text
.global _start
_start:
    // CFINV - 反转 C 标志位
    // NZCV = NZCV XOR 0x20000000
    
    // 初始 NZCV = 0
    msr nzcv, xzr       // NZCV = 0
    
    cfinv               // C should flip: NZCV = 0x20000000
    
    mrs x0, nzcv        // Read NZCV
    
    brk #0
