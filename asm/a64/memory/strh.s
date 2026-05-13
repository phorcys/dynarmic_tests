/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000001234"
}
*/
// Test: STRH Wt, [Xn, #simm] - Store Register Halfword
// Stores a 16-bit value to memory

.text
.global _start
_start:
    sub sp, sp, #16
    
    // Setup
    mov w0, #0x1234
    
    // STRH: store halfword
    strh w0, [sp]
    
    // Load back to verify
    ldrh w0, [sp]
    
    brk #0
