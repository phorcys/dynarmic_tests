/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000001",
    "R2": "0xFFFFFFFF",
    "R3": "0xFFFFFFFF"
  }
}
*/
.text
.global _start
_start:
    mvn r0, #0
    mov r1, #0
    mov r4, #1
    mov r5, #1
    umlal r0, r1, r4, r5   @ 0xFFFFFFFF + 1 => carry into high
    add r0, r0, #1         @ normalize to low 0

    mvn r2, #0
    mvn r3, #0
    mov r4, #0
    mov r5, #1
    umlal r2, r3, r4, r5   @ unchanged -1

    bkpt #0
