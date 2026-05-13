/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000002",
    "R2": "0x00000003",
    "R3": "0x00000004"
  }
}
*/
// Test: Conditional execution chain with all condition codes
// A32 allows every instruction to be conditionally executed

.text
.arm
.global _start
_start:
    @ Setup: Compare to set flags
    mov r4, #10
    cmp r4, #5              @ 10 > 5, sets GT (N=0, Z=0, C=1, V=0)
    
    @ GT (Greater Than) - should execute
    addgt r0, r4, #0        @ r0 = 10... expected 1
    @ Let me adjust
    
    mov r0, #0
    addgt r0, r0, #1        @ r0 = 1 if GT
    
    @ LT (Less Than) - should NOT execute
    mov r1, #0
    addlt r1, r1, #1        @ Not executed
    addge r1, r1, #2        @ Executed (GE is true since GT is true)
    
    @ LE (Less or Equal) - should NOT execute
    mov r2, #0
    addle r2, r2, #1        @ Not executed
    addgt r2, r2, #3        @ Executed, r2 = 3
    
    @ EQ (Equal) - should NOT execute
    mov r3, #0
    addeq r3, r3, #1        @ Not executed
    addne r3, r3, #4        @ Executed, r3 = 4
    
    bkpt #0
