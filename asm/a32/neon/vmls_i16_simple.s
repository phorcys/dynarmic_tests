/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0007000700070007" }
}
*/
.text
.global _start
_start:
    @ VMLS.I16: Vector Multiply Subtract
    
    vmov.i64 d0, #0x000A000A000A000A
    vmov.i64 d1, #0x0001000100010001
    vmov.i64 d2, #0x0003000300030003
    
    vmls.i16 d0, d1, d2  @ d0 = [10-3, 10-3, 10-3, 10-3] = [7, 7, 7, 7]
    
    bkpt #0