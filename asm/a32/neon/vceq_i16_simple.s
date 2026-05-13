/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0xFFFFFFFFFFFFFFFF" }
}
*/
.text
.global _start
_start:
    @ VCEQ.I16: Vector Compare Equal
    
    vmov.i64 d0, #0x0002000200020002
    vmov.i64 d1, #0x0002000200020002
    
    vceq.i16 d0, d0, d1  @ d0 = [all equal] = [FFFF, FFFF, FFFF, FFFF]
    
    bkpt #0