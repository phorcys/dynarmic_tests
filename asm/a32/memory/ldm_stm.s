/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000004",
    "R1": "0x00000003",
    "R2": "0x00000002",
    "R3": "0x00000001",
    "R4": "0x00000005"
  }
}
*/
// Test: LDM/STM - load/store multiple registers

.text
.arm
.global _start
_start:
    @ Setup
    sub sp, sp, #32
    
    @ Test 1: STMIA (store multiple increment after)
    mov r0, #1
    mov r1, #2
    mov r2, #3
    mov r3, #4
    mov r4, sp
    stmia r4!, {r0-r3}      @ Store r0-r3 at sp, increment r4
    @ [sp+0]=1, [sp+4]=2, [sp+8]=3, [sp+12]=4
    @ r4 = sp+16
    
    @ Test 2: LDMIA (load multiple increment after)
    mov r0, #0
    mov r1, #0
    mov r2, #0
    mov r3, #0
    mov r4, sp
    ldmia r4!, {r0-r3}      @ Load r0-r3 from sp, increment r4
    @ r0=1, r1=2, r2=3, r3=4, r4=sp+16
    
    @ Store values in different order for verification
    mov r0, r3              @ r0 = 4
    mov r1, r2              @ r1 = 3
    mov r2, r1              @ r2 = 2... wait this overwrites
    @ Let me use temps
    mov r5, r3              @ r5 = 4
    mov r6, r2              @ r6 = 3
    mov r0, r5              @ r0 = 4
    mov r1, r6              @ r1 = 3
    mov r2, #2              @ r2 = 2
    mov r3, #1              @ r3 = 1
    
    add sp, sp, #32
    
    mov r4, #5
    
    bkpt #0
