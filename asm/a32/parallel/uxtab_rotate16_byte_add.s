/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000024" }
}
*/
.text
.global _start
_start:
    mov r1, #2
    ldr r2, =0x11223344
    uxtab r0, r1, r2, ror #16
    bkpt #0
.ltorg
