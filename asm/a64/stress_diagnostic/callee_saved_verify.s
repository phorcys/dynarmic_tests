/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x0000000000000000"
  }
}
*/
// Callee-saved register integrity test (X19-X28)
// 
// PURPOSE: Verify that callee-saved registers (X19-X28) are properly preserved
//          across function calls in the JIT.
// 
// In ARM64 ABI: X19-X28 must be preserved by the callee
// In LoongArch64 JIT: 
//   - s0-s5 (r23-r28) are RESERVED for JIT internal use (GprState, GprHalt, etc.)
//   - s6-s8 (r29-r31) are available for allocation
//
// TEST METHOD:
// 1. Store unique values to X19-X28
// 2. Call function that uses all caller-saved registers intensively
// 3. Verify X19-X28 are unchanged
// 4. X0 = 0 means ALL callee-saved registers preserved correctly
//    X0 > 0 indicates how many registers were corrupted
//
// POTENTIAL BUG EXPOSURE:
// If the LoongArch64 register allocator incorrectly uses reserved registers
// (s0-s5 for GprState etc.), this test will FAIL with X0 > 0.

.text
.global _start
_start:
    // Initialize callee-saved registers with unique values
    // Using values > 1000 to distinguish from function computation results
    mov x19, #1001
    mov x20, #1002
    mov x21, #1003
    mov x22, #1004
    mov x23, #1005
    mov x24, #1006
    mov x25, #1007
    mov x26, #1008
    mov x27, #1009
    mov x28, #1010
    
    // Call a function that heavily uses all caller-saved registers
    // This should create maximum register pressure
    bl heavy_computation
    
    // === VERIFICATION ===
    // X0 = count of corrupted callee-saved registers
    // If register allocator works correctly, X0 should be 0
    mov x0, #0
    
    // Check X19
    cmp x19, #1001
    cset x1, ne
    add x0, x0, x1
    
    // Check X20
    cmp x20, #1002
    cset x1, ne
    add x0, x0, x1
    
    // Check X21
    cmp x21, #1003
    cset x1, ne
    add x0, x0, x1
    
    // Check X22
    cmp x22, #1004
    cset x1, ne
    add x0, x0, x1
    
    // Check X23
    cmp x23, #1005
    cset x1, ne
    add x0, x0, x1
    
    // Check X24
    cmp x24, #1006
    cset x1, ne
    add x0, x0, x1
    
    // Check X25
    cmp x25, #1007
    cset x1, ne
    add x0, x0, x1
    
    // Check X26
    cmp x26, #1008
    cset x1, ne
    add x0, x0, x1
    
    // Check X27
    cmp x27, #1009
    cset x1, ne
    add x0, x0, x1
    
    // Check X28
    cmp x28, #1010
    cset x1, ne
    add x0, x0, x1
    
    // X0 = 0 if all callee-saved registers preserved
    // X0 > 0 if some registers were corrupted
    brk #0

// Function that uses all caller-saved registers intensively
heavy_computation:
    // Prologue - standard frame setup
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Use ALL caller-saved registers (X0-X18) with complex operations
    // This creates maximum pressure on the register allocator
    mov x0, #1
    mov x1, #2
    mov x2, #4
    mov x3, #8
    mov x4, #16
    mov x5, #32
    mov x6, #64
    mov x7, #128
    mov x8, #256
    mov x9, #512
    mov x10, #1024
    mov x11, #2048
    mov x12, #4096
    mov x13, #8192
    mov x14, #16384
    mov x15, #32768
    mov x16, #65536
    mov x17, #131072
    mov x18, #262144
    
    // Complex computation using all registers multiple times
    // Forces allocator to keep all values "live"
    add x0, x0, x1
    add x0, x0, x2
    add x0, x0, x3
    add x0, x0, x4
    add x0, x0, x5
    add x0, x0, x6
    add x0, x0, x7
    add x0, x0, x8
    add x0, x0, x9
    add x0, x0, x10
    add x0, x0, x11
    add x0, x0, x12
    add x0, x0, x13
    add x0, x0, x14
    add x0, x0, x15
    add x0, x0, x16
    add x0, x0, x17
    add x0, x0, x18
    
    // Multiply operations
    mul x1, x1, x2
    mul x3, x3, x4
    mul x5, x5, x6
    mul x7, x7, x8
    
    // Add results
    add x0, x0, x1
    add x0, x0, x3
    add x0, x0, x5
    add x0, x0, x7
    
    // Logical operations
    and x9, x9, x10
    orr x11, x11, x12
    eor x13, x13, x14
    
    // Final add
    add x0, x0, x9
    add x0, x0, x11
    add x0, x0, x13
    
    // Epilogue - restore frame and return
    ldp x29, x30, [sp], #16
    ret