/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000006" }
}
*/
.text
.global _start
_start:
    @ SBC: Subtract with Carry (Rd = Rn - Rm - !C)
    mov r0, #10
    mov r1, #4
    
    @ Set carry flag (C=1 for no borrow)
    cmp r0, #0       @ 10 - 0, sets C=1
    
    sbc r0, r0, r1   @ r0 = 10 - 4 - 0 = 6
    
    @ Now test with C=0
    mov r0, #10
    cmp r0, r0       @ 10 - 10 = 0, sets C=0 (borrow)
    
    sbc r0, r0, r1   @ r0 = 10 - 4 - 1 = 5
    
    bkpt #0
