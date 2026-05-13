/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" }
}
*/
.text
.global _start
_start:
    mov r1, #3
    mov r2, #4
    mov r3, #12
    mls r0, r1, r2, r3   @ 12 - 12 = 0
    bkpt #0
