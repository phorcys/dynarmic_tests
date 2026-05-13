/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000000002" }
}
*/
.text
.global _start
_start:
    @ VQSHRN - Saturating Shift Right Narrow
    @ Shift right by 16 and narrow from 32-bit to 16-bit
    mov r0, #0x00020000   @ Value to shift
    mov r1, #0
    vmov d0, r0, r1      @ D0 = 0x0000000000020000
    vqshrn.u32 d0, q0, #16
    bkpt #0
.ltorg
