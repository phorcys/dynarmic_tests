/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4010000000000000" }
}
*/
.text
.global _start
_start:
    @ VDIV.F64: Vector Divide (double precision)
    @ VDIV.F64 Dd, Dn, Dm
    
    vmov.f64 d1, #8.0
    vmov.f64 d2, #2.0
    
    vdiv.f64 d0, d1, d2     @ D0 = 8.0 / 2.0 = 4.0 = 0x4010000000000000
    
    bkpt #0