/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000007" }
}
*/
.text
.global _start
_start:
    @ SBC: Subtract with Carry
    @ SBC Rd, Rn, #imm
    @ Rd = Rn - imm - !C
    
    movs r0, #0             @ Clear flags, C=1
    mov r1, #8
    
    sbc r0, r1, #0          @ R0 = 8 - 0 - 0 = 8
    
    @ Now test with C=0 (borrow occurred)
    cmp r0, #0              @ Set flags based on r0=8, C=1
    
    @ Let's try a simpler test
    movs r0, #0             @ C=1 (no borrow from 0-0)
    mov r1, #8
    sbc r0, r1, #1          @ R0 = 8 - 1 - 0 = 7
    
    bkpt #0
.ltorg
