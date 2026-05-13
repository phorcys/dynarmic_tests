/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x40000000"
  }
}
*/
.text
.arm
.global _start
_start:
    @ VSQRT - Square root of floating point
    @ VSQRT.F32 S0, S1
    vmov s1, #4.0
    vsqrt.f32 s0, s1      @ sqrt(4.0) = 2.0 = 0x40000000
    vmov r0, s0
    bkpt #0
