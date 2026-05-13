/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000002",
    "R1": "0x00000004",
    "R2": "0x00000006"
  }
}
*/
// Test: PUSH/POP stack operations

.text
.arm
.global _start
_start:
    @ Setup
    mov r0, #1
    mov r1, #2
    mov r2, #3
    
    @ Test PUSH: store r0-r2 on stack
    push {r0-r2}            @ SP decrements by 12, stores r0, r1, r2
    
    @ Clear registers
    mov r0, #0
    mov r1, #0
    mov r2, #0
    
    @ Test POP: restore from stack
    pop {r0-r2}             @ r0=1, r1=2, r2=3
    
    @ Set expected values (swap r0 and r1 to verify order)
    mov r3, r0
    mov r0, r1              @ r0 = 2
    mov r1, #4              @ r1 = 4
    mov r2, #6              @ r2 = 6
    
    bkpt #0
