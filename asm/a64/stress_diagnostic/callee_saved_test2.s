/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x0000000000000000"
  }
}
*/
// Callee-saved register test - moderate complexity
// Uses multiple caller-saved registers but simpler operations

.text
.global _start
_start:
    // Set callee-saved registers with unique values
    mov x19, #100
    mov x20, #200
    mov x21, #300
    mov x22, #400
    mov x23, #500
    mov x24, #600
    mov x25, #700
    mov x26, #800
    mov x27, #900
    mov x28, #1000
    
    // Call function
    bl compute_func
    
    // Verify all callee-saved registers
    mov x0, #0
    
    cmp x19, #100
    cset x1, ne
    add x0, x0, x1
    
    cmp x20, #200
    cset x1, ne
    add x0, x0, x1
    
    cmp x21, #300
    cset x1, ne
    add x0, x0, x1
    
    cmp x22, #400
    cset x1, ne
    add x0, x0, x1
    
    cmp x23, #500
    cset x1, ne
    add x0, x0, x1
    
    cmp x24, #600
    cset x1, ne
    add x0, x0, x1
    
    cmp x25, #700
    cset x1, ne
    add x0, x0, x1
    
    cmp x26, #800
    cset x1, ne
    add x0, x0, x1
    
    cmp x27, #900
    cset x1, ne
    add x0, x0, x1
    
    cmp x28, #1000
    cset x1, ne
    add x0, x0, x1
    
    brk #0

compute_func:
    stp x29, x30, [sp, #-16]!
    
    // Use caller-saved registers
    mov x0, #1
    mov x1, #2
    mov x2, #3
    mov x3, #4
    mov x4, #5
    mov x5, #6
    mov x6, #7
    mov x7, #8
    mov x8, #9
    mov x9, #10
    mov x10, #11
    mov x11, #12
    mov x12, #13
    mov x13, #14
    mov x14, #15
    mov x15, #16
    mov x16, #17
    mov x17, #18
    mov x18, #19
    
    // Simple add
    add x0, x0, x1
    add x0, x0, x2
    add x0, x0, x3
    
    ldp x29, x30, [sp], #16
    ret
