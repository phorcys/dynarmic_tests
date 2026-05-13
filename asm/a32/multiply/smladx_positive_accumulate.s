/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000010" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00020003
    ldr r2, =0x00040001
    mov r3, #2
    smladx r0, r1, r2, r3
    bkpt #0
.ltorg
