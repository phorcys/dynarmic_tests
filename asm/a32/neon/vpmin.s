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
    // VPMIN - 向量对最小值
    vmov.i32 d0, #1
    vmov.i32 d1, #2
    
    vpmin.s16 d0, d0, d1
    
    bkpt #0
