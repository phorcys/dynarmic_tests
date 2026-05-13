/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000004" }
}
*/
.text
.global _start
_start:
    mov r1, #5
    ldr r2, =0x0080FF00
    sxtab r0, r1, r2, ror #8
    bkpt #0
.ltorg
