/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000001",
    "R6": "0x00000001",
    "R7": "0x12345678"
  }
}
*/
// Test: Halfword operations with conditional branch
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
    mov r0, #2
    strh r0, [r5, #4]       @ [sp+4] = 0x0002
    
    ldrh r1, [r5, #4]       @ r1 = 2
    sub r1, r1, #1          @ r1 = 1
    strh r1, [r5, #4]       @ [sp+4] = 0x0001
    
    ldrh r0, [r5, #4]       @ r0 = 1
    
    @ Conditional branch based on halfword value
    mov r6, #0
    cmp r0, #0
    beq skip_nonzero
    mov r6, #1              @ r6 = 1 (nonzero path taken)
skip_nonzero:
    
    ldr r7, [r5, #16]       @ r7 = 0x12345678
    
    add sp, sp, #32
    bkpt #0
