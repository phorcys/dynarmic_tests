/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x12345678" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x12345678
    mov r2, #0
    uqadd16 r0, r1, r2
    bkpt #0
.ltorg
