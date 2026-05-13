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
    ldrsh r0, [sp, #2]
    pop {r4}
    bkpt #0
