/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000032",
    "R1": "0x00000032",
    "R2": "0x00000064"
  }
}
*/
.text
.global _start
_start:
    mov r0, #50
    mov r1, #50
    qadd r2, r0, r1
    bkpt #0
