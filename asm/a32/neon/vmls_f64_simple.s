/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0xBFF0000000000000" }
}
*/
.text
.global _start
_start:
    @ VMLS.F64: Vector Multiply Subtract (double precision)
    @ VMLS.F64 Dd, Dn, Dm
    @ Dd = Dd - Dn * Dm
    
    vmov.f64 d0, #5.0
    vmov.f64 d1, #2.0
    vmov.f64 d2, #3.0
    
    vmls.f64 d0, d1, d2     @ D0 = 5.0 - 2.0 * 3.0 = 5.0 - 6.0 = -1.0 = 0xBFF0000000000000
    
    bkpt #0