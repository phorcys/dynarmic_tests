/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0xFFFFFFFFFFFFFFFF" }
}
*/
.text
.global _start
_start:
    @ VCGT.I16: Vector Compare Greater Than (signed)
    
    vmov.i64 d0, #0x0005000500050005
    vmov.i64 d1, #0x0002000200020002
    
    vcgt.s16 d0, d0, d1  @ d0 = [all greater] = [FFFF, FFFF, FFFF, FFFF]
    
    bkpt #0