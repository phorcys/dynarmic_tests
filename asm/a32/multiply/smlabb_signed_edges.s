/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000010",
    "R1": "0xFFFFFFF8",
    "R2": "0x00000000",
    "R3": "0xFFFFFFFF"
  }
}
*/
.text
.global _start
_start:
    mov r6, #10
    ldr r4, =0x00000003
    ldr r5, =0x00000002
    smlabb r0, r4, r5, r6   @ 16

    mov r6, #0
    mvn r4, #1              @ low = 0xFFFE = -2
    mov r5, #4
    smlabb r1, r4, r5, r6   @ -8

    mov r6, #12
    mvn r4, #0              @ low = -1
    mov r5, #12
    smlabb r2, r4, r5, r6   @ 0

    mov r6, #0
    mvn r4, #0              @ -1
    mov r5, #1
    smlabb r3, r4, r5, r6   @ -1

    bkpt #0
