/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x11223344",
    "R1": "0x55667788",
    "R2": "0x99AABBCC",
    "R3": "0xDDEEFF00"
  }
}
*/
.text
.global _start
_start:
    ldr r0, lit0
    ldr r1, lit1
    ldr r2, lit2
    ldr r3, lit3
    b end

lit0:
    .word 0x11223344
lit1:
    .word 0x55667788
lit2:
    .word 0x99AABBCC
lit3:
    .word 0xDDEEFF00

end:
    bkpt #0
