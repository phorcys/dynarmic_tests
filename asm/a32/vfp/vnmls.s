/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x4000000000000000" }
}
*/
.text
.global _start
_start:
    @ VNMLS: Negated Multiply-Subtract
    @ S0 = -S0 + S1 * S2
    @ S1 = 2.0, S2 = 3.0, S0 = 6.0
    @ S0 = -6.0 + 2.0 * 3.0 = -6.0 + 6.0 = 0.0 = 0x00000000
    @ D0 = S1:S0 = 0x40000000:00000000
    vmov.f32 s1, #2.0
    vmov.f32 s2, #3.0
    vmov.f32 s0, #6.0
    vnmls.f32 s0, s1, s2
    bkpt #0