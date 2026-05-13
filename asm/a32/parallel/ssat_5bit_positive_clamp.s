/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000014",
    "R1": "0x0000000F"
  }
}
*/
.text
.global _start
_start:
    mov r0, #20
    ssat r1, #5, r0
    bkpt #0
