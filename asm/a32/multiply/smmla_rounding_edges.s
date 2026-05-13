/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000020",
    "R1": "0x00000010",
    "R2": "0xFFFFFFFF",
    "R3": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x10000000
    ldr r5, =0x00000100
    mov r6, #16
    smmla r0, r4, r5, r6

    ldr r4, =0x10000000
    ldr r5, =0x00000100
    mov r6, #0
    smmla r1, r4, r5, r6

    mvn r4, #0
    mov r5, #1
    mov r6, #0
    smmla r2, r4, r5, r6

    mov r6, #2
    smmla r3, r4, r5, r6

    bkpt #0
