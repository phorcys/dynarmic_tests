/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000FFFF",
    "R1": "0xFFFF0000",
    "R2": "0x00000000",
    "R3": "0x12000078"
  }
}
*/
.text
.global _start
_start:
    mvn r0, #0
    bfc r0, #16, #16

    mvn r1, #0
    bfc r1, #0, #16

    mvn r2, #0
    bfc r2, #0, #32

    ldr r3, =0x12345678
    bfc r3, #8, #16

    bkpt #0
