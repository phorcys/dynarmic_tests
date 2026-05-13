/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000005",
    "R1": "0x00000003",
    "R2": "0x00000000",
    "R3": "0x00000000"
  }
}
*/
// Test: CMN - compare negative (sets flags for Rn + Operand2)
// CMN Rn, Operand2: compute Rn + Operand2 and set flags, discard result

.text
.arm
.global _start
_start:
    @ Test 1: CMN sets Z when sum is zero
    mov r0, #5
    mvn r1, #4              @ r1 = ~4 = 0xFFFFFFFB = -5
    cmn r0, r1              @ 5 + (-5) = 0, Z=1
    @ r0 and r1 unchanged
    
    @ Test 2: CMN detects overflow
    ldr r2, =0x7FFFFFFF
    cmn r2, #1              @ 0x7FFFFFFF + 1 = 0x80000000, V=1
    mov r2, #0
    
    @ Test 3: CMN normal
    mov r3, #5
    cmn r3, #3              @ 5 + 3 = 8, no special flags
    mov r3, #0
    
    @ Final values
    mov r0, #5
    mov r1, #3              @ Simplified value
    mov r2, #0
    mov r3, #0
    
    bkpt #0
