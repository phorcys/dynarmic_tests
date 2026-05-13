/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4000000040A00000" }
}
*/
.text
.global _start
_start:
    @ VFMS.F32: Fused Multiply Subtract
    @ VFMS Sd, Sn, Sm: Sd = Sd - Sn * Sm
    
    vmov.f32 s0, #7.0    @ s0 = 7.0
    vmov.f32 s1, #2.0    @ s1 = 2.0
    vmov.f32 s2, #1.0    @ s2 = 1.0
    
    @ VFMS computes: Sd = Sd - Sn * Sm = 7.0 - 2.0 * 1.0 = 5.0
    vfms.f32 s0, s1, s2  @ s0 = 7.0 - 2.0 * 1.0 = 5.0 = 0x40A00000
                         @ D0 = S1:S0 = 0x40000000_40A00000
    
    bkpt #0