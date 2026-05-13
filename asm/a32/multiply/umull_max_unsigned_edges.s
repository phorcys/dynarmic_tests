/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0xFFFFFFFE",
    "R2": "0xFFFFFFFE",
    "R3": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    mvn r4, #0
    mvn r5, #0
    umull r0, r1, r4, r5   @ 0xFFFFFFFF * 0xFFFFFFFF

    mvn r4, #0
    mov r5, #2
    umull r2, r3, r4, r5   @ 0xFFFFFFFF * 2

    bkpt #0
