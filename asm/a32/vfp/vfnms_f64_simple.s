/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x3FF0000000000000" }
}
*/
.text
.global _start
_start:
    @ VFNMS.F64: Fused Negate Multiply Subtract (double precision)
    @ VFNMS.F64 Dd, Dn, Dm
    @ Dd = -Dd - Dn * Dm (fused)
    @ But QEMU says 1.0, so it might be Dd = -Dd + Dn * Dm
    
    vmov.f64 d0, #1.0
    vmov.f64 d1, #2.0
    vmov.f64 d2, #1.0
    
    vfnms.f64 d0, d1, d2    @ D0 = -1.0 + 2.0 * 1.0 = 1.0 = 0x3FF0000000000000
    
    bkpt #0