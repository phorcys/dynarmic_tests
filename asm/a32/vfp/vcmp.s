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
    @ VCMP - Compare floating point
    @ VCMP.F32 S0, S1
    vmov s0, #1.0
    vmov s1, #1.0
    vcmp.f32 s0, s1
    vmrs apsr_nzcv, fpscr
    moveq r0, #1          @ Z flag set if equal
    movne r0, #0
    bkpt #0
