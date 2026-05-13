/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000012" }
}
*/
.text
.global _start
_start:
    ldr r4, =0x807F1234
    push {r4}
    mov r1, sp
    mov r2, #1
    ldrb r0, [r1, r2]
    pop {r4}
    bkpt #0
