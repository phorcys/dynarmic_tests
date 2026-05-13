/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00010001"
  }
}
*/
.text
.global _start
_start:
    mov r1, #0x10000
    mov r2, #1
    qadd r0, r1, r2
    bkpt #0
