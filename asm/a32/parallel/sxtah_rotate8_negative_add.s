/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFF8002" }
}
*/
.text
.global _start
_start:
    mov r1, #1
    ldr r2, =0x00800100
    sxtah r0, r1, r2, ror #8
    bkpt #0
.ltorg
