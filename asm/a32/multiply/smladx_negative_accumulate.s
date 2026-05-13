/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000003" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x0001FFFF
    ldr r2, =0xFFFF0001
    mov r3, #1
    smladx r0, r1, r2, r3
    bkpt #0
.ltorg
