/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000145"
  }
}
*/
// Extreme register spill test - all registers live simultaneously
// Tests register allocator with maximum pressure
// Uses callee-saved registers (X19-X28) which must be preserved
// Expected: X0 = 0xF0 = 240 (sum of X1-X15, which is 1+2+...+15 = 120, times 2)

.text
.global _start
_start:
    // Initialize X1-X15 with unique values
    mov x1, #1
    mov x2, #2
    mov x3, #3
    mov x4, #4
    mov x5, #5
    mov x6, #6
    mov x7, #7
    mov x8, #8
    mov x9, #9
    mov x10, #10
    mov x11, #11
    mov x12, #12
    mov x13, #13
    mov x14, #14
    mov x15, #15
    
    // Save callee-saved registers that we'll use
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!
    stp x25, x26, [sp, #-16]!
    stp x27, x28, [sp, #-16]!
    
    // Use callee-saved registers as additional "live" values
    mov x19, #16
    mov x20, #17
    mov x21, #18
    mov x22, #19
    mov x23, #20
    mov x24, #21
    mov x25, #22
    mov x26, #23
    mov x27, #24
    mov x28, #25
    
    // Now compute sum in X0: sum of X1-X15 (120) + X19-X28 (205) = 325
    // But we want to test register pressure - all values should be live
    // Use a complex expression that keeps all values live
    
    // First half: X1-X15
    add x0, x1, x2       // x0 = 3
    add x0, x0, x3       // x0 = 6
    add x0, x0, x4       // x0 = 10
    add x0, x0, x5       // x0 = 15
    add x0, x0, x6       // x0 = 21
    add x0, x0, x7       // x0 = 28
    add x0, x0, x8       // x0 = 36
    add x0, x0, x9       // x0 = 45
    add x0, x0, x10      // x0 = 55
    add x0, x0, x11      // x0 = 66
    add x0, x0, x12      // x0 = 78
    add x0, x0, x13      // x0 = 91
    add x0, x0, x14      // x0 = 105
    add x0, x0, x15      // x0 = 120
    
    // Add second half: X19-X28
    add x0, x0, x19      // x0 = 136
    add x0, x0, x20      // x0 = 153
    add x0, x0, x21      // x0 = 171
    add x0, x0, x22      // x0 = 190
    add x0, x0, x23      // x0 = 210
    add x0, x0, x24      // x0 = 231
    add x0, x0, x25      // x0 = 253
    add x0, x0, x26      // x0 = 276
    add x0, x0, x27      // x0 = 300
    add x0, x0, x28      // x0 = 325 = 0x145
    
    // Verify by computing the expected value differently
    // 1+2+...+25 = 25*26/2 = 325
    
    // Restore callee-saved registers
    ldp x27, x28, [sp], #16
    ldp x25, x26, [sp], #16
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    
    brk #0
