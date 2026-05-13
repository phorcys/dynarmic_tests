/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x3f8000003f800000" }
}
*/
.text
.global _start
_start:
    @ VRECPS: Reciprocal Step
    @ VRECPS.F32 Dd, Dn, Dm
    @ Dd = 2 - Dn * Dm
    
    vmov.f32 s0, #1.0       @ S0 = 1.0
    vmov.f32 s1, #1.0       @ S1 = 1.0
    
    vrecps.f32 d0, d0, d0   @ 2 - 1.0 * 1.0 = 1.0
    
    bkpt #0
.ltorg
