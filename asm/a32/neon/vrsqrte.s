/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x3eff80003eff80007f8000007f800000" }
}
*/
.text
.global _start
_start:
    @ VRSQRTE: Reciprocal Square Root Estimate
    @ VRSQRTE.F32 Q0, Q0
    vmov.f32 s0, #4.0
    vmov.f32 s1, #4.0
    vrsqrte.f32 q0, q0
    @ Approximate 1/sqrt(4) = 0.5
    bkpt #0
