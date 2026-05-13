/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000110" }
}
*/
.text
.global _start
_start:
    mov r1, #0x10
    ldr r2, =0x00800001
    sxtah r0, r1, r2, ror #24
    bkpt #0
.ltorg
