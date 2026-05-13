/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x11111111",
    "R1": "0x22222222"
  }
}
*/
.text
.arm
.global _start
_start:
    @ SWP word exchange
    sub sp, sp, #16
    mov r0, #0x11
    orr r0, r0, r0, lsl #8
    orr r0, r0, r0, lsl #16  @ R0 = 0x11111111
    str r0, [sp]              @ Store data on stack
    
    ldr r0, [sp]              @ R0 = data = 0x11111111
    mov r1, #0x22
    orr r1, r1, r1, lsl #8
    orr r1, r1, r1, lsl #16  @ R1 = 0x22222222
    swp r0, r1, [sp]         @ R0 = old data, memory = R1
    bkpt #0
