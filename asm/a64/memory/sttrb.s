/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000042"
}
*/
// Test: STTRB Wt, [Xn, #simm] - Store Register Byte (unprivileged)
// Stores a byte to memory with unprivileged access

.text
.global _start
_start:
    sub sp, sp, #16
    
    // Setup
    mov w0, #0x42
    
    // STTRB: store byte unprivileged
    sttrb w0, [sp]
    
    // Load back to verify
    ldrb w0, [sp]
    
    brk #0
