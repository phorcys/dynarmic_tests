/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFE",
    "R1": "0xFFFFFFFF",
    "R2": "0x00000000",
    "R3": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    mov r0, #0
    mov r1, #0
    mvn r4, #0
    mov r5, #2
    smlal r0, r1, r4, r5    @ -2

    mov r2, #1
    mov r3, #0
    mvn r4, #0
    mov r5, #1
    umlal r2, r3, r4, r5    @ 1 + 0xFFFFFFFF = 0x1_00000000

    bkpt #0
