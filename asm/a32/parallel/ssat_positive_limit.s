/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000007F" }
}
*/
.text
.global _start
_start:
    mov r1, #127
    ssat r0, #8, r1
    bkpt #0
