/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xFFFFFFFE"
  }
}
*/
.text
.global _start
_start:
    // SDIV: Signed division
    // -4 / 2 = -2
    mov r0, #-4
    mov r1, #2
    sdiv r0, r0, r1
    
    bkpt #0
