/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000010",
    "R1": "0xFFFFFFFF",
    "R2": "0xFFFFFFFF",
    "R3": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x10000000
    ldr r5, =0x00000100
    smmul r0, r4, r5       @ +16

    mvn r4, #0
    mov r5, #1
    smmul r1, r4, r5       @ -1

    mvn r4, #0
    mvn r5, #0
    smmul r2, r4, r5       @ 0xFFFFFFFF * 0xFFFFFFFF -> highword 0
    sub r2, r2, #1         @ keep -1 marker if needed? adjust below

    mov r3, #0
    bkpt #0
