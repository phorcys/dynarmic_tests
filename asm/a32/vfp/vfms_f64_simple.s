/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4000000000000000" }
}
*/
.text
.global _start
_start:
    @ VFMS.F64: Fused Multiply Subtract (double precision)
    @ VFMS.F64 Dd, Dn, Dm
    @ Dd = Dd - Dn * Dm (fused, single rounding)
    
    vmov.f64 d0, #3.0
    vmov.f64 d1, #2.0
    vmov.f64 d2, #0.5
    
    vfms.f64 d0, d1, d2     @ D0 = 3.0 - 2.0 * 0.5 = 3.0 - 1.0 = 2.0 = 0x4000000000000000
    
    bkpt #0