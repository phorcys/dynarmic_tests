/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x0000000000000000"
  }
}
*/
// Register pressure test - NO function calls
// Tests register allocation under pressure by using ALL 29 GPRs simultaneously
//
// This test exposes bugs where register allocator might incorrectly use
// reserved registers (s0-s5 for GprState, etc.) for temporary values.
//
// Each register X0-X28 is set to a unique value, then we verify all values
// after performing complex operations.
//
// X0 = 0 means all registers retained correct values
// X0 > 0 indicates count of corrupted registers

.text
.global _start
_start:
    // Initialize ALL general-purpose registers with unique values
    mov x0, #0
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
    mov x16, #16
    mov x17, #17
    mov x18, #18
    mov x19, #19
    mov x20, #20
    mov x21, #21
    mov x22, #22
    mov x23, #23
    mov x24, #24
    mov x25, #25
    mov x26, #26
    mov x27, #27
    mov x28, #28
    
    // Perform complex operations using temporaries
    // This should NOT corrupt any of the existing register values
    // because the register allocator should use spill slots
    
    // Store all registers to stack
    sub sp, sp, #256
    stp x0, x1, [sp, #0]
    stp x2, x3, [sp, #16]
    stp x4, x5, [sp, #32]
    stp x6, x7, [sp, #48]
    stp x8, x9, [sp, #64]
    stp x10, x11, [sp, #80]
    stp x12, x13, [sp, #96]
    stp x14, x15, [sp, #112]
    stp x16, x17, [sp, #128]
    stp x18, x19, [sp, #144]
    stp x20, x21, [sp, #160]
    stp x22, x23, [sp, #176]
    stp x24, x25, [sp, #192]
    stp x26, x27, [sp, #208]
    stp x28, x29, [sp, #224]
    
    // Do some computation with temporaries
    // Using X29 (FP) as temporary (not callee-saved in this context)
    mov x29, #100
    add x29, x29, #50       // x29 = 150
    add x29, x29, #50       // x29 = 200
    
    // Restore all registers
    ldp x0, x1, [sp, #0]
    ldp x2, x3, [sp, #16]
    ldp x4, x5, [sp, #32]
    ldp x6, x7, [sp, #48]
    ldp x8, x9, [sp, #64]
    ldp x10, x11, [sp, #80]
    ldp x12, x13, [sp, #96]
    ldp x14, x15, [sp, #112]
    ldp x16, x17, [sp, #128]
    ldp x18, x19, [sp, #144]
    ldp x20, x21, [sp, #160]
    ldp x22, x23, [sp, #176]
    ldp x24, x25, [sp, #192]
    ldp x26, x27, [sp, #208]
    ldp x28, x29, [sp, #224]  // Restore x29 to original value
    add sp, sp, #256
    
    // Verify all registers have their original values
    // Use X0 to count mismatches
    mov x0, #0
    
    // Check X1-X28 (skip X0 since we use it for counter)
    cmp x1, #1
    cset x29, ne
    add x0, x0, x29
    
    cmp x2, #2
    cset x29, ne
    add x0, x0, x29
    
    cmp x3, #3
    cset x29, ne
    add x0, x0, x29
    
    cmp x4, #4
    cset x29, ne
    add x0, x0, x29
    
    cmp x5, #5
    cset x29, ne
    add x0, x0, x29
    
    cmp x6, #6
    cset x29, ne
    add x0, x0, x29
    
    cmp x7, #7
    cset x29, ne
    add x0, x0, x29
    
    cmp x8, #8
    cset x29, ne
    add x0, x0, x29
    
    cmp x9, #9
    cset x29, ne
    add x0, x0, x29
    
    cmp x10, #10
    cset x29, ne
    add x0, x0, x29
    
    cmp x11, #11
    cset x29, ne
    add x0, x0, x29
    
    cmp x12, #12
    cset x29, ne
    add x0, x0, x29
    
    cmp x13, #13
    cset x29, ne
    add x0, x0, x29
    
    cmp x14, #14
    cset x29, ne
    add x0, x0, x29
    
    cmp x15, #15
    cset x29, ne
    add x0, x0, x29
    
    cmp x16, #16
    cset x29, ne
    add x0, x0, x29
    
    cmp x17, #17
    cset x29, ne
    add x0, x0, x29
    
    cmp x18, #18
    cset x29, ne
    add x0, x0, x29
    
    cmp x19, #19
    cset x29, ne
    add x0, x0, x29
    
    cmp x20, #20
    cset x29, ne
    add x0, x0, x29
    
    cmp x21, #21
    cset x29, ne
    add x0, x0, x29
    
    cmp x22, #22
    cset x29, ne
    add x0, x0, x29
    
    cmp x23, #23
    cset x29, ne
    add x0, x0, x29
    
    cmp x24, #24
    cset x29, ne
    add x0, x0, x29
    
    cmp x25, #25
    cset x29, ne
    add x0, x0, x29
    
    cmp x26, #26
    cset x29, ne
    add x0, x0, x29
    
    cmp x27, #27
    cset x29, ne
    add x0, x0, x29
    
    cmp x28, #28
    cset x29, ne
    add x0, x0, x29
    
    // X0 = 0 means all 28 registers (X1-X28) have correct values
    brk #0
