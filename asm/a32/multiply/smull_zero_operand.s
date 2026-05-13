/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000", "R1": "0x00000000" }
}
*/
.text
.global _start
_start:
    mov r2, #0
    ldr r3, =0x12345678
    smull r0, r1, r2, r3
    bkpt #0
.ltorg
