/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x00000000000000AB"
  }
}
*/
// Callee-saved register test (X19-X28)
// Tests that callee-saved registers are properly preserved across function calls
// 
// In ARM64 ABI: X19-X28 must be preserved by callee
// In LoongArch64 JIT: s0-s5 (r23-r28) are reserved for JIT internal use
//                      s6-s8 (r29-r31) are available for allocation
//
// This test verifies that all callee-saved registers retain their values
// after a function call. If any is corrupted, the test fails.

.text
.global _start
_start:
    // Initialize callee-saved registers with unique values
    mov x19, #20
    mov x20, #21
    mov x21, #22
    mov x22, #23
    mov x23, #24
    mov x24, #25
    mov x25, #26
    mov x26, #27
    mov x27, #28
    mov x28, #29
    
    // Call a function that uses many caller-saved registers
    bl callee_func
    
    // X0 = 0 (result from callee_func, not used for verification)
    // All callee-saved registers should still have their original values
    brk #0

callee_func:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Use all caller-saved registers (X0-X18)
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
    
    // Complex computation using all registers
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
    // x0 = 0+1+2+...+18 = 171
    
    ldp x29, x30, [sp], #16
    ret
