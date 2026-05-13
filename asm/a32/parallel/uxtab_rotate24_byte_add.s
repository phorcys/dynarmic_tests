/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000014" }
}
*/
.text
.global _start
_start:
    mov r1, #3
    ldr r2, =0x11223344
    uxtab r0, r1, r2, ror #24
    bkpt #0
.ltorg
