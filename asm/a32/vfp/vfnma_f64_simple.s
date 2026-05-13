/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0xC008000000000000" }
}
*/
.text
.global _start
_start:
    @ VFNMA.F64: Fused Negate Multiply Add (double precision)
    @ VFNMA.F64 Dd, Dn, Dm
    @ Dd = -Dd + Dn * Dm (fused)
    
    vmov.f64 d0, #1.0
    vmov.f64 d1, #2.0
    vmov.f64 d2, #1.0
    
    vfnma.f64 d0, d1, d2    @ D0 = -1.0 + 2.0 * 1.0 = -1.0 + 2.0 = 1.0
                            @ Hmm, QEMU says -3.0 = 0xC008000000000000
                            @ So it's actually: D0 = -Dd - Dn * Dm = -1.0 - 2.0 * 1.0 = -3.0
    
    bkpt #0