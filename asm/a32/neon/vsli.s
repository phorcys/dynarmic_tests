/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" },
  "VecData": { "D0": "0x0001000000010000" }
}
*/
.text
.global _start
_start:
    // VSLI - 向量左移插入
    vmov.i32 d0, #0
    vmov.i32 d1, #1
    
    vsli.32 d0, d1, #16
    
    bkpt #0
