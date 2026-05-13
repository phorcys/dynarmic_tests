/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00008000" }
}
*/
.text
.global _start
_start:
    mov r1, #1
    ldr r2, =0x00007FFF
    sxtah r0, r1, r2
    bkpt #0
.ltorg
