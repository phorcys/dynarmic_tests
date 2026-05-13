/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x3eff80003eff80007f8000007f800000" }
}
*/
.text
.global _start
_start:
    @ VRECPE: Reciprocal Estimate
    @ VRECPE.F32 Q0, Q0
    vmov.f32 s0, #2.0
    vmov.f32 s1, #2.0
    vrecpe.f32 q0, q0
    @ Approximate 1/2.0 = 0.5
    bkpt #0
