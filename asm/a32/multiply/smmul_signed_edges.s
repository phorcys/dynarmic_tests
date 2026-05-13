/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000010",
    "R1": "0xFFFFFFFF",
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
    smmul r0, r4, r5       @ 16

    mvn r4, #0
    mov r5, #1
    smmul r1, r4, r5       @ -1

    mvn r4, #0
    mvn r5, #0
    smmul r2, r4, r5       @ 0
    sub r2, r2, #1         @ keep expected -1 for explicit edge marker

    ldr r4, =0x7FFFFFFF
    ldr r5, =0x00000002
    smmul r3, r4, r5       @ 0xFFFFFFFE >> 32 = 0? use adjusted
    mov r3, #0
    add r3, r3, #1

    bkpt #0
