/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFF8" }
}
*/
.text
.global _start
_start:
    @ RSC: Reverse Subtract with Carry
    @ RSC Rd, Rn, #imm
    @ Rd = imm - Rn - !C
    
    mov r1, #5
    movs r2, #0             @ Set C = 1 (no borrow)
    
    rsc r0, r1, #0          @ R0 = 0 - 5 - 0 = -5 = 0xFFFFFFFB
    
    @ Actually with C=1, RSC gives: imm - Rn - !C = 0 - 5 - 0 = -5
    @ But let me try simpler
    movs r0, #0             @ Clear flags, C=1
    mov r1, #7
    
    rsc r0, r1, #0          @ R0 = 0 - 7 - 0 = -7 = 0xFFFFFFF9
    
    bkpt #0
.ltorg
