/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000000",
    "R2": "0xFFFFFFFF",
    "R3": "0xFFFFFFFF"
  }
}
*/
.text
.global _start
_start:
    mov r4, #1
    smull r0, r1, r4, r4    @ 1 * 1 = 1

    mvn r4, #0
    mov r5, #1
    smull r2, r3, r4, r5    @ -1 * 1 = -1

    bkpt #0
