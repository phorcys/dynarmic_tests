/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFF8",
    "R1": "0x00000000",
    "R2": "0x00000000",
    "R3": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    mov r4, #5
    mov r5, #4
    mov r6, #12
    mls r0, r4, r5, r6     @ -8

    mvn r2, #0
    mov r3, #0
    mov r4, #1
    mov r5, #1
    umlal r2, r3, r4, r5   @ 0xFFFFFFFF + 1 = 0x1_00000000

    bkpt #0
