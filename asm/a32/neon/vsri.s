/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" },
  "VecData": { "D0": "0x0000000000000000" }
}
*/
.text
.global _start
_start:
    // VSRI - 向量右移插入
    vmov.i32 d0, #0
    vmov.i32 d1, #1
    
    vsri.32 d0, d1, #16
    
    bkpt #0