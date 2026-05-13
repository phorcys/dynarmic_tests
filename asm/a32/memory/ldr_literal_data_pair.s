/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000042", "R1": "0x00000043" }
}
*/
.text
.global _start
_start:
    ldr r0, =data
    ldr r1, [r0, #4]
    ldr r0, [r0]
    bkpt #0
.ltorg
data:
    .word 0x42
    .word 0x43
