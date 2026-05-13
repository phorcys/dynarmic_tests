/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000002",
    "R2": "0x00000003"
  }
}
*/
// VCMP + VMRS APSR_nzcv transfer.

.text
.arm
.global _start
_start:
    vmov s0, #1.0
    vmov s1, #1.0
    vcmp.f32 s0, s1
    vmrs apsr_nzcv, fpscr
    moveq r0, #1

    vmov s2, #1.0
    vmov s3, #2.0
    vcmp.f32 s2, s3
    vmrs apsr_nzcv, fpscr
    movlt r1, #2

    vcmp.f32 s3, s2
    vmrs apsr_nzcv, fpscr
    movgt r2, #3

    bkpt #0
