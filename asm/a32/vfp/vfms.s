/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "D0": "0x4000000000000000"
  }
}
*/
.text
.global _start
_start:
    @ VFMS: Fused Multiply-Subtract
    @ ARM semantics: S0 = S0 + (-S1 * S2) = S0 - S1 * S2
    @ S1 = 2.0, S2 = 3.0, S0 = 6.0
    @ S0 = 6.0 - 2.0 * 3.0 = 0.0 = 0x00000000
    vmov.f32 s1, #2.0
    vmov.f32 s2, #3.0
    vmov.f32 s0, #6.0
    vfms.f32 s0, s1, s2
    bkpt #0