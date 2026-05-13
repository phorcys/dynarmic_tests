/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000007F" }
}
*/
.text
.global _start
_start:
    ldr r4, =0x007F0000
    push {r4}
    mov r1, sp
    mov r2, #2
    ldrsb r0, [r1, r2]
    pop {r4}
    bkpt #0
