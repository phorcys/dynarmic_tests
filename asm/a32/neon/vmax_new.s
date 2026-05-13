/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x3f800000400000004040000040800000" }
}
*/
.text
.global _start
_start:
    @ VMAX: Vector Maximum
    @ VMAX.F32 Q0, Q0, Q1
    vmov.f32 s0, #1.0
    vmov.f32 s1, #2.0
    vmov.f32 s2, #3.0
    vmov.f32 s3, #4.0
    @ Q0 = [1.0, 2.0], Q1 = [3.0, 4.0]
    vmax.f32 q0, q0, q1
    @ Q0 = [3.0, 4.0]
    bkpt #0
