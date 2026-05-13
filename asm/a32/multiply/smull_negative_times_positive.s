/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFF6", "R1": "0xFFFFFFFF" }
}
*/
.text
.global _start
_start:
    mvn r2, #4          @ -5
    mov r3, #1
    lsl r3, r3, #1      @ 2
    smull r0, r1, r2, r3
    bkpt #0
