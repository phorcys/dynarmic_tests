/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000000F" }
}
*/
.text
.global _start
_start:
    mov r1, #15
    usat r0, #4, r1
    bkpt #0
