/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0xFFFFFFF8",
    "R2": "0x0000000C",
    "R3": "0xFFFFFFFF"
  }
}
*/
.text
.global _start
_start:
    mov r4, #3
    mov r5, #4
    mov r6, #-12
    mla r0, r4, r5, r6     @ 0

    mov r4, #5
    mov r5, #4
    mov r6, #12
    mls r1, r4, r5, r6     @ -8

    mov r4, #3
    mov r5, #4
    mov r6, #0
    mla r2, r4, r5, r6     @ 12

    mvn r4, #0
    mov r5, #1
    mov r6, #0
    mla r3, r4, r5, r6     @ -1

    bkpt #0
