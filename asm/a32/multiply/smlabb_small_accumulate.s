/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000010" }
}
*/
.text
.global _start
_start:
    mov r3, #10
    ldr r1, =0x00000003
    ldr r2, =0x00000002
    smlabb r0, r1, r2, r3
    bkpt #0
.ltorg
