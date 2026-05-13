/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4000000000000000" }
}
*/
.text
.global _start
_start:
    @ VFMA.F64: Fused Multiply Add (double precision)
    @ VFMA.F64 Dd, Dn, Dm
    @ Dd = Dd + Dn * Dm (fused, single rounding)
    
    vmov.f64 d0, #1.0
    vmov.f64 d1, #2.0
    vmov.f64 d2, #0.5
    
    vfma.f64 d0, d1, d2     @ D0 = 1.0 + 2.0 * 0.5 = 1.0 + 1.0 = 2.0 = 0x4000000000000000
    
    bkpt #0