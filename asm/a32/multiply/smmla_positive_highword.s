/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x01000000" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x10000000
    ldr r2, =0x10000000
    mov r3, #0
    smmla r0, r1, r2, r3
    bkpt #0
.ltorg
