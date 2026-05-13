/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000080" }
}
*/
.text
.global _start
_start:
    ldr r4, =0x807F1234
    push {r4}
    ldrb r0, [sp, #3]
    pop {r4}
    bkpt #0
