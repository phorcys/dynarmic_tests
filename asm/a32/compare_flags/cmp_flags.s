/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000005",
    "R1": "0x00000003",
    "R2": "0x00000000"
  }
}
*/
// Test: CMP - compare and set flags
// CMP Rn, Operand2: compute Rn - Operand2 and set flags

.text
.arm
.global _start
_start:
    @ Test 1: CMP equal (Z=1)
    mov r0, #5
    cmp r0, #5              @ 5 - 5 = 0, Z=1, C=1
    @ Flags set but r0 unchanged
    
    @ Test 2: CMP greater (C=1, Z=0)
    mov r1, #5
    cmp r1, #3              @ 5 - 3 = 2, no borrow, C=1, Z=0
    moveq r2, #1            @ Not executed (Z=0)
    movne r2, #0            @ Executed (Z=0)
    
    @ Test 3: CMP less (C=0 for unsigned, N=1 for signed)
    mov r3, #3
    cmp r3, #5              @ 3 - 5 = -2, borrow (C=0), N=1
    
    @ Final values
    mov r0, #5
    mov r1, #3
    @ r2 = 0 from conditional move
    
    bkpt #0
