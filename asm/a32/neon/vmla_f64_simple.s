/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4026000000000000" }
}
*/
.text
.global _start
_start:
    @ VMLA.F64: Vector Multiply Accumulate (double precision)
    @ VMLA.F64 Dd, Dn, Dm
    @ Dd = Dd + Dn * Dm
    
    @ D0 = 5.0, D1 = 2.0, D2 = 3.0
    @ D0 = 5.0 + 2.0 * 3.0 = 5.0 + 6.0 = 11.0
    
    vmov.f64 d0, #5.0
    vmov.f64 d1, #2.0
    vmov.f64 d2, #3.0
    
    vmla.f64 d0, d1, d2     @ D0 = 11.0 = 0x4026000000000000
    
    bkpt #0