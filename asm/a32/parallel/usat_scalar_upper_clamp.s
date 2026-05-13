/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x000000FF",
    "R1": "0x0000000F"
  }
}
*/
.text
.global _start
_start:
    mov r0, #255
    usat r1, #4, r0
    bkpt #0
