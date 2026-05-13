/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000011"
  }
}
*/
.text
.global _start
_start:
    mov r3, #7
    ldr r1, =0x00020001
    ldr r2, =0x00040003
    smladx r0, r1, r2, r3   @ 7 + 10 = 17
    bkpt #0
