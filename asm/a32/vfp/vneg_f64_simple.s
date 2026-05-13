/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0xC010000000000000" }
}
*/
.text
.global _start
_start:
    @ VNEG.F64: Vector Negate (double precision)
    @ VNEG.F64 Dd, Dm
    
    vmov.f64 d1, #4.0
    
    vneg.f64 d0, d1         @ D0 = -4.0 = 0xC010000000000000
    
    bkpt #0
