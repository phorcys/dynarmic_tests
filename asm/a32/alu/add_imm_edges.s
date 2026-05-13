/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00001000",
    "R1": "0x80000000",
    "R2": "0x00000000",
    "R3": "0x00000000"
  }
}
*/
.text
.arm
.global _start
_start:
    ldr r4, =0x00000FFF
    add r0, r4, #1

    ldr r4, =0x7FFFFFFF
    add r1, r4, #1

    mvn r4, #0
    add r2, r4, #1

    ldr r3, =0xFFFFFFFB
    add r3, r3, #5

    bkpt #0
