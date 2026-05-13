/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00002234" }
}
*/
.text
.global _start
_start:
    mov r1, #1
    ldr r2, =0x11223344
    sxtah r0, r1, r2, ror #8
    bkpt #0
.ltorg
