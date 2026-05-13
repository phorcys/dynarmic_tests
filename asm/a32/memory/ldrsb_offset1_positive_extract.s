/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000007F" }
}
*/
.text
.global _start
_start:
    ldr r4, =0x00007F00
    push {r4}
    ldrsb r0, [sp, #1]
    pop {r4}
    bkpt #0
