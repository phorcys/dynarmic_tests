/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000080" }
}
*/
.text
.global _start
_start:
    mov r1, #1
    ldr r2, =0x7F00FF00
    sxtab r0, r1, r2, ror #24
    bkpt #0
.ltorg
