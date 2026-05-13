/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x40000000c1400000" }
}
*/
.text
.global _start
_start:
    @ VNMLA: Negated Multiply-Add
    @ S0 = -S0 - S1 * S2
    @ S1 = 2.0, S2 = 3.0, S0 = 6.0
    @ S0 = -6.0 - 2.0 * 3.0 = -6.0 - 6.0 = -12.0 = 0xC1400000
    @ D0 = S1:S0 = 0x40000000:c1400000
    vmov.f32 s1, #2.0
    vmov.f32 s2, #3.0
    vmov.f32 s0, #6.0
    vnmla.f32 s0, s1, s2
    bkpt #0