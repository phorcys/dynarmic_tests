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
.global _start
_start:
    ldr r0, =0x11111111
    ldr r1, =0x22222222
    sub sp, sp, #8
    mov r2, sp
    strd r0, r1, [r2]
    ldrd r4, r5, [sp]
    mov r0, r4
    mov r1, r5
    add sp, sp, #8
    bkpt #0
