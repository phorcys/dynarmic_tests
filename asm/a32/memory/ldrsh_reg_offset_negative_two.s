/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFF8000" }
}
*/
.text
.global _start
_start:
    ldr r4, =0x80000000
    push {r4}
    mov r1, sp
    mov r2, #2
    ldrsh r0, [r1, r2]
    pop {r4}
    bkpt #0
