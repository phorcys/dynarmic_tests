/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0x00000000",
    "R2": "0xFFFFFFFF",
    "R3": "0x00000000"
  }
}
*/
.text
.arm
.global _start
_start:
    mvn r2, #0
    mov r3, #1
    umull r0, r1, r2, r3

    mvn r4, #0
    mov r5, #1
    umull r2, r3, r4, r5
    bkpt #0
