/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xBF800000"
  }
}
*/
.text
.arm
.global _start
_start:
    @ VNEG - Negate floating point
    @ VNEG.F32 S0, S1
    vmov s1, #1.0
    vneg.f32 s0, s1       @ -1.0 = 0xBF800000
    vmov r0, s0
    bkpt #0
