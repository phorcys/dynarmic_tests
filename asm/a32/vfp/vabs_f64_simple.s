/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4014000000000000" }
}
*/
.text
.global _start
_start:
    @ VABS.F64: Vector Absolute (double precision)
    @ VABS.F64 Dd, Dm
    
    vmov.f64 d1, #-5.0
    
    vabs.f64 d0, d1         @ D0 = |-5.0| = 5.0 = 0x4014000000000000
    
    bkpt #0
