/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4014000000000000" }
}
*/
.text
.global _start
_start:
    @ VADD.F64: Vector Add (double precision)
    @ VADD.F64 Dd, Dn, Dm
    
    vmov.f64 d1, #3.0
    vmov.f64 d2, #2.0
    
    vadd.f64 d0, d1, d2     @ D0 = 3.0 + 2.0 = 5.0 = 0x4014000000000000
    
    bkpt #0
