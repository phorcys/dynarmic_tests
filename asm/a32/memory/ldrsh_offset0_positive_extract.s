/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00007FFF" }
}
*/
.text
.global _start
_start:
    ldr r4, =0x00007FFF
    push {r4}
    ldrsh r0, [sp]
    pop {r4}
    bkpt #0
