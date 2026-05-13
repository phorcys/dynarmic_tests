/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x4000000040800000" }
}
*/
.text
.global _start
_start:
    @ VMLA: Vector Multiply Accumulate
    @ VMLA.F32 D0, D1, D2 - D0 = D0 + D1 * D2
    vmov.f32 s0, #1.0
    vmov.f32 s1, #1.0
    vmov.f32 s2, #2.0
    vmov.f32 s3, #1.0
    vmov.f32 s4, #1.5
    vmov.f32 s5, #1.0
    vmla.f32 d0, d1, d2
    @ D0 = [1.0, 1.0] + [2.0, 1.0] * [1.5, 1.0]
    @ D0 = [1.0 + 3.0, 1.0 + 1.0] = [4.0, 2.0]
    bkpt #0