/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X4": "0x0000000000001234",
    "X5": "0x0000000000005678"
  }
}
*/
// Test: LDP (pre-indexed) - Load Pair with pre-increment

.text
.global _start
_start:
    // Use stack for storage
    sub sp, sp, #64
    
    mov x0, sp
    mov x1, #0x1234
    mov x2, #0x5678
    
    // Store at sp+16
    stp x1, x2, [x0, #16]
    
    // LDP with pre-index: x0 += 16, then load from [x0]
    mov x0, sp
    ldp x4, x5, [x0, #16]!  // x0 = sp + 16, load from sp + 16
    
    add sp, sp, #64
    brk #0
