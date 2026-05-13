/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFF80" }
}
*/
.text
.global _start
_start:
    mov r1, #0
    ldr r2, =0x0080FF00
    sxtab r0, r1, r2, ror #16
    bkpt #0
.ltorg
