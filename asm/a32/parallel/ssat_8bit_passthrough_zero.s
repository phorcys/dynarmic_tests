/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" }
}
*/
.text
.global _start
_start:
    mov r1, #0
    ssat r0, #8, r1
    bkpt #0
