/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000003",
    "R1": "0xFFFFFFFF",
    "R2": "0x01000000",
    "R3": "0xFFFFFFFF"
  }
}
*/
.text
.global _start
_start:
    mov r4, #1
    lsl r4, r4, #16
    mov r5, #3
    mov r6, #0
    smlawb r0, r4, r5, r6   @ 3

    mvn r4, #0              @ -1
    mov r5, #1
    mov r6, #0
    smlawb r1, r4, r5, r6   @ -1

    ldr r4, =0x10000000
    ldr r5, =0x10000000
    mov r6, #0
    smmla r2, r4, r5, r6    @ 0x01000000

    mvn r4, #0
    mov r5, #1
    mov r6, #0
    smmla r3, r4, r5, r6    @ -1

    bkpt #0
