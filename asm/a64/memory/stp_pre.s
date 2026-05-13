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
// Test: STP (pre-indexed) - Store Pair with pre-increment

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #64
    
    mov x0, sp
    mov x1, #0x1234
    mov x2, #0x5678
    
    // STP with pre-index: x0 += 16, then store x1, x2 at [x0]
    stp x1, x2, [x0, #16]!  // x0 = sp + 16, store at sp + 16
    
    // Load back from sp + 16 to verify
    ldp x4, x5, [sp, #16]   // x4 = 0x1234, x5 = 0x5678
    
    add sp, sp, #64
    brk #0
