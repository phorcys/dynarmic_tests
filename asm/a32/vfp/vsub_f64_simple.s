/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4000000000000000" }
}
*/
.text
.global _start
_start:
    @ VSUB.F64: Vector Subtract (double precision)
    @ VSUB.F64 Dd, Dn, Dm
    
    vmov.f64 d1, #5.0
    vmov.f64 d2, #3.0
    
    vsub.f64 d0, d1, d2     @ D0 = 5.0 - 3.0 = 2.0 = 0x4000000000000000
    
    bkpt #0
