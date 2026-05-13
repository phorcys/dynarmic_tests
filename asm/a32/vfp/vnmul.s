/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x40000000c0c00000" }
}
*/
.text
.global _start
_start:
    @ VNMUL: Negated Multiply
    @ S0 = -S1 * S2
    @ S1 = 2.0, S2 = 3.0
    @ S0 = -(2.0 * 3.0) = -6.0 = 0xC0C00000
    @ D0 = S1:S0 = 0x40000000:c0c00000
    vmov.f32 s1, #2.0
    vmov.f32 s2, #3.0
    vnmul.f32 s0, s1, s2
    bkpt #0