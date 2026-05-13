/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R2": "0x00000001",
    "R3": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    mov r0, #0
    movw r1, #0xffff
    mov r2, #0
    mov r3, #0

    tst r0, r1
    bne 1f
    mov r2, #1
    b 2f
1:
    mov r3, #1
2:
    bkpt #0
