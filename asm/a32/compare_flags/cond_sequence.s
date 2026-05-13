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
// Test: Multiple conditional instructions in sequence
// A32 allows almost every instruction to be conditionally executed

.text
.arm
.global _start
_start:
    @ Test: Conditional add sequence
    mov r0, #0
    mov r1, #0
    mov r2, #0
    mov r3, #0
    
    @ Compare to set flags
    mov r4, #5
    cmp r4, #3              @ 5 > 3, GT condition true
    
    @ These should all execute (GT condition)
    addgt r0, r0, #1        @ r0 = 1
    addgt r1, r0, #1        @ r1 = 2
    addgt r2, r1, #1        @ r2 = 3
    addgt r3, r2, #1        @ r3 = 4
    
    bkpt #0
