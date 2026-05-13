/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" }
}
*/
.text
.global _start
_start:
    mov r1, #2
    ldr r2, =0x00030000
    smulwt r0, r1, r2
    bkpt #0
.ltorg
