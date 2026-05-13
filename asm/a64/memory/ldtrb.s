/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000042"
}
*/
// Test: LDTRB Wt, [Xn, #simm] - Load Register Byte (unprivileged)
// Loads a byte from memory with unprivileged access

.text
.global _start
_start:
    sub sp, sp, #16
    
    // Setup: store a byte
    mov w0, #0x42
    strb w0, [sp]
    
    // Clear register
    mov x0, #0
    
    // LDTRB: load byte unprivileged
    ldtrb w0, [sp]
    
    brk #0
