/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000055" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #8
    mov r1, sp
    mov r2, #3
    mov r3, #0x55
    strb r3, [r1, r2]
    ldrb r0, [sp, #3]
    add sp, sp, #8
    bkpt #0
