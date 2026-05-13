/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFF8" }
}
*/
.text
.global _start
_start:
    @ RSB: Reverse Subtract
    @ RSB Rd, Rn, #imm
    @ Rd = imm - Rn
    
    mov r1, #8
    
    rsb r0, r1, #0          @ R0 = 0 - 8 = -8 = 0xFFFFFFF8
    
    bkpt #0
.ltorg
