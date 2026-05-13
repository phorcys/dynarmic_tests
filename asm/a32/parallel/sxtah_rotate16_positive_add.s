/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00007FFF" }
}
*/
.text
.global _start
_start:
    mov r1, #0
    ldr r2, =0x7FFF0000
    sxtah r0, r1, r2, ror #16
    bkpt #0
.ltorg
