/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000000004" }
}
*/
.text
.global _start
_start:
    @ VQRSHRN - Saturating Rounding Shift Right Narrow
    @ Shift right by 1 with rounding, narrow from 32-bit to 16-bit
    @ 7 >> 1 with rounding = 4
    mov r0, #7
    mov r1, #0
    vmov d0, r0, r1
    vqrshrn.u32 d0, q0, #1
    bkpt #0
.ltorg
