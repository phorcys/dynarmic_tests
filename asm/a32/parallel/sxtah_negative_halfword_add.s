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
    ldr r2, =0x0000FF80
    sxtah r0, r1, r2
    bkpt #0
.ltorg
