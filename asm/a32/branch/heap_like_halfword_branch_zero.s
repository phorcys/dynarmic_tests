/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0x00000000",
    "R6": "0x00000001",
    "R7": "0x00000000"
  }
}
*/
// Test: Halfword operations with zero value branch
// Verifies LDRH, STRH, and branch work correctly together

.text
.arm
.global _start
_start:
    sub sp, sp, #32
    mov r5, sp
    
    @ Setup: store a word
    movw r2, #0x5678
    movt r2, #0x1234
    str r2, [r5, #16]       @ [sp+16] = 0x12345678
    
    @ Test halfword operations
    mov r0, #1
    strh r0, [r5, #4]       @ [sp+4] = 0x0001
    
    ldrh r1, [r5, #4]       @ r1 = 1
    sub r1, r1, #1          @ r1 = 0
    strh r1, [r5, #4]       @ [sp+4] = 0x0000
    
    ldrh r0, [r5, #4]       @ r0 = 0
    
    @ Conditional branch based on zero halfword value
    mov r6, #0
    cmp r0, #0
    bne skip_zero
    mov r6, #1              @ r6 = 1 (zero path taken)
    str r0, [r5, #16]       @ [sp+16] = 0 (cleared)
skip_zero:
    
    ldr r7, [r5, #16]       @ r7 = 0
    
    add sp, sp, #32
    bkpt #0
