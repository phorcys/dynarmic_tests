/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" },
  "VecData": { "D0": "0x0002000200010001" }
}
*/
.text
.global _start
_start:
    // VPMAX - 向量对最大值
    vmov.i32 d0, #1
    vmov.i32 d1, #2
    
    vpmax.s16 d0, d0, d1
    
    bkpt #0