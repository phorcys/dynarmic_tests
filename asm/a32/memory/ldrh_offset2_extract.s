/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000807F" }
}
*/
.text
.global _start
_start:
    ldr r4, =0x807F1234
    push {r4}
    ldrh r0, [sp, #2]
    pop {r4}
    bkpt #0
