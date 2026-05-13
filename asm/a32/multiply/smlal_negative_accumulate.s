/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFFB", "R1": "0xFFFFFFFF" }
}
*/
.text
.global _start
_start:
    mov r0, #1
    mov r1, #0
    mvn r2, #2          @ -3
    mov r3, #1
    lsl r3, r3, #1      @ 2
    smlal r0, r1, r2, r3
    bkpt #0
