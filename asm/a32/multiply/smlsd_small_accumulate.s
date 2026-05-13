/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001" }
}
*/
.text
.global _start
_start:
    mov r3, #0
    ldr r1, =0x00010002
    ldr r2, =0x00010001
    smlsd r0, r1, r2, r3
    bkpt #0
.ltorg
