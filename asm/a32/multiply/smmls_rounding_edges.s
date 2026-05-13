/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000010",
    "R1": "0x00000020",
    "R2": "0x00000000",
    "R3": "0xFFFFFFFE"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x10000000
    ldr r5, =0x00000100
    mov r6, #32
    smmls r0, r4, r5, r6

    ldr r4, =0x10000000
    ldr r5, =0x00000100
    mov r6, #48
    smmls r1, r4, r5, r6

    mvn r4, #0
    mov r5, #1
    mov r6, #0
    smmls r2, r4, r5, r6

    mov r6, #-2
    smmls r3, r4, r5, r6

    bkpt #0
