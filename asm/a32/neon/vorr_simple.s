/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0007000700070007" }
}
*/
.text
.global _start
_start:
    @ VORR: Vector OR
    
    vmov.i64 d0, #0x0004000400040004
    vmov.i64 d1, #0x0003000300030003
    
    vorr d0, d0, d1      @ d0 = [4|3, 4|3, 4|3, 4|3] = [7, 7, 7, 7]
    
    bkpt #0