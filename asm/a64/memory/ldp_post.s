/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X4": "0x0000000000001234",
    "X5": "0x0000000000005678"
  }
}
*/
// Test: LDP (post-indexed) - Load Pair with post-increment

.text
.global _start
_start:
    // Use stack for storage
    sub sp, sp, #64
    
    mov x0, sp
    mov x1, #0x1234
    mov x2, #0x5678
    
    // First store values on stack
    stp x1, x2, [x0]
    
    // Load with post-index
    mov x0, sp
    ldp x4, x5, [x0], #16  // Load x4, x5 from [sp], then x0 += 16
    
    add sp, sp, #64
    brk #0
