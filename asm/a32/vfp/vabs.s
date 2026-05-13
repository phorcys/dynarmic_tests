/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001"
  }
}
*/
.text
.arm
.global _start
_start:
    @ VABS - Absolute value of floating point
    @ VABS.F32 S0, S1
    vmov s1, #-1.0
    vabs.f32 s0, s1       @ |−1.0| = 1.0
    vmov r0, s0
    @ r0 now contains 1.0 in IEEE 754 format (0x3F800000)
    @ Let me just check if positive
    cmp r0, #0
    movgt r0, #1          @ If positive, r0 = 1
    movle r0, #0          @ If negative or zero, r0 = 0
    bkpt #0
