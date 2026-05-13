/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00020003
    ldr r2, =0x00030002
    mov r3, #0
    smlsd r0, r1, r2, r3
    bkpt #0
.ltorg
