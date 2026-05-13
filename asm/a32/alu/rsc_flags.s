/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000004" }
}
*/
.text
.global _start
_start:
    @ RSC: Reverse Subtract with Carry (Rd = Rm - Rn - !C)
    mov r0, #4
    mov r1, #10
    
    @ Set carry flag (C=1)
    cmp r0, #0       @ 4 - 0, sets C=1
    
    rsc r0, r0, r1   @ r0 = 10 - 4 - 0 = 6
    
    @ Now test with C=0
    mov r2, #10
    cmp r2, r2       @ 10 - 10 = 0, sets C=0
    
    mov r0, #4
    mov r1, #10
    rsc r0, r0, r1   @ r0 = 10 - 4 - 1 = 5
    
    @ Another test
    mov r0, #6
    mov r1, #10
    cmp r0, #0       @ C=1
    rsc r0, r0, r1   @ r0 = 10 - 6 - 0 = 4
    
    bkpt #0
