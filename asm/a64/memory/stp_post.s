/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x0000000000001234",
    "X2": "0x0000000000005678",
    "X4": "0x0000000000001234",
    "X5": "0x0000000000005678"
  }
}
*/
// Test: STP (post-indexed) - Store Pair with post-increment
// This test verifies that STP writes to memory correctly
// We verify by reading back with LDP

.text
.global _start
_start:
    // Allocate stack space for storage
    sub sp, sp, #64
    
    mov x0, sp
    mov x1, #0x1234
    mov x2, #0x5678
    
    // STP with post-index: store x1, x2 at [x0], then x0 += 16
    stp x1, x2, [x0], #16   // x0 = sp + 16 after
    
    // Load back from original location (sp) to verify
    ldp x4, x5, [sp]        // x4 = 0x1234, x5 = 0x5678
    
    add sp, sp, #64
    brk #0