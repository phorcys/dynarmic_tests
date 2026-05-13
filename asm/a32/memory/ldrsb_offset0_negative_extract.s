/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFF80" }
}
*/
.text
.global _start
_start:
    ldr r4, =0x00000080
    push {r4}
    ldrsb r0, [sp]
    pop {r4}
    bkpt #0
