/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000000008" }
}
*/
.text
.global _start
_start:
    @ VQSHLU - Saturating Shift Left Unsigned
    @ Shift left by 1, saturating to unsigned
    mov r0, #4
    mov r1, #0
    vmov d0, r0, r1
    vqshlu.s32 d0, #1
    bkpt #0
.ltorg
