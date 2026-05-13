/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000034" }
}
*/
.text
.global _start
_start:
    mov r1, #1
    ldr r2, =0x11223344
    uxtab r0, r1, r2, ror #8
    bkpt #0
.ltorg
