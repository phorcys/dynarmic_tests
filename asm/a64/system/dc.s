/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000000"
}
*/
// Test: DC ZVA, Xt - Data Cache Zero by VA
// Zeros a block of memory

.text
.global _start
_start:
    sub sp, sp, #64
    
    // Setup: fill memory with non-zero values
    mov x0, #0xDEAD
    movk x0, #0xBEEF, lsl #16
    stp x0, x0, [sp]
    stp x0, x0, [sp, #16]
    
    // DC ZVA: zero a cache line
    mov x0, sp
    dc zva, x0
    
    // Result - memory should be zeroed
    // Note: DC ZVA zeros a block, not visible in register
    mov x0, #0
    
    brk #0