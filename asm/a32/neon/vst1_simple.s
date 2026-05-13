/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000400000003" }
}
*/
.text
.global _start
_start:
    @ VST1 - Store single-element structure from one lane
    mov r0, #3
    mov r1, #4
    vmov d0, r0, r1      @ D0 = 0x0000000400000003
    @ Allocate space on stack
    sub sp, sp, #16
    vst1.64 {d0}, [sp]
    add sp, sp, #16
    bkpt #0
.ltorg
