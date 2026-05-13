/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0x00000001",
    "R2": "0x00000001",
    "R3": "0x00000000"
  }
}
*/
// Test: SUBS - subtract and set flags

.text
.arm
.global _start
_start:
    @ Test 1: SUBS with result zero (Z=1, C=1)
    mov r0, #5
    subs r0, r0, #5         @ 5 - 5 = 0, Z=1, C=1 (no borrow)
    mov r0, #0              @ Store result
    
    @ Test 2: SUBS with borrow (C=0)
    mov r1, #0
    subs r1, r1, #1         @ 0 - 1 = 0xFFFFFFFF, C=0 (borrow)
    mov r1, #1              @ Store indicator for borrow
    
    @ Test 3: SUBS normal
    mov r2, #5
    subs r2, r2, #3         @ 5 - 3 = 2, C=1 (no borrow)
    mov r2, #1              @ Store indicator
    
    @ Test 4: SUBS negative result (N=1)
    mov r3, #3
    subs r3, r3, #5         @ 3 - 5 = -2, N=1
    mov r3, #0              @ Clear for test
    
    bkpt #0
