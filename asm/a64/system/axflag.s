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
    // AXFlag - ARM NZCV 转换为外部标志格式
    
    // 初始 NZCV = 0 (N=0, Z=0, C=0, V=0)
    msr nzcv, xzr
    
    axflag
    
    mrs x0, nzcv
    
    brk #0
