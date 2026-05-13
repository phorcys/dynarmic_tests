/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFF0002" }
}
*/
.text
.global _start
_start:
    mov r1, #2
    mov r2, #1
    qsax r0, r1, r2
    bkpt #0
