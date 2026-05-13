/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000013",
    "R1": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    mov r0, #21
    mov r1, #0
    ldr r2, =0x00020001
    ldr r3, =0x00040003
    smlsldx r0, r1, r2, r3  @ 21 + (1*4 - 2*3) = 19
    bkpt #0
