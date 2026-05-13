/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xF000000F"
  }
}
*/
.text
.global _start
_start:
    // ROR: Rotate right
    // 0x000000FF rotated right by 4 = 0xF000000F
    mov r0, #0xFF
    mov r1, #4
    ror r0, r0, r1
    
    bkpt #0
