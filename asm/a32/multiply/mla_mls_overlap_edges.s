/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000000B",
    "R1": "0xFFFFFFFB",
    "R2": "0x00000007",
    "R3": "0x0000000E"
  }
}
*/
.text
.global _start
_start:
    mov r0, #5
    mov r4, #2
    mov r5, #3
    mla r0, r4, r5, r0

    mov r1, #1
    mov r4, #2
    mov r5, #3
    mls r1, r4, r5, r1

    mov r2, #7
    mov r4, #1
    mov r5, #0
    mla r2, r4, r5, r2

    mov r3, #20
    mov r4, #2
    mov r5, #3
    mls r3, r4, r5, r3

    bkpt #0
