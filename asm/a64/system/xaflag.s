/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000080000000" },
  "VecData": {}
}
*/
.text
.global _start
_start:
    // XAFlag - 外部标志格式转换为 ARM NZCV
    
    // 初始 NZCV = 0 (N=0, Z=0, C=0, V=0)
    msr nzcv, xzr
    
    xaflag
    
    mrs x0, nzcv
    
    brk #0
