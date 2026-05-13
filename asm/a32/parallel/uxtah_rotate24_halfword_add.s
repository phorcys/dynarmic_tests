/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00004412" }
}
*/
.text
.global _start
_start:
    mov r1, #1
    ldr r2, =0x11223344
    uxtah r0, r1, r2, ror #24
    bkpt #0
.ltorg
