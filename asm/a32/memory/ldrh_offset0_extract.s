/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00001234" }
}
*/
.text
.global _start
_start:
    ldr r4, =0x807F1234
    push {r4}
    ldrh r0, [sp]
    pop {r4}
    bkpt #0
