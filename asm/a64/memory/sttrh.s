/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000001234"
}
*/
// Test: STTRH Wt, [Xn, #simm] - Store Register Halfword (unprivileged)
// Stores a halfword to memory with unprivileged access

.text
.global _start
_start:
    sub sp, sp, #16
    
    // Setup
    mov w0, #0x1234
    
    // STTRH: store halfword unprivileged
    sttrh w0, [sp]
    
    // Load back to verify
    ldrh w0, [sp]
    
    brk #0
