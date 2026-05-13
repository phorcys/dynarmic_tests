/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000001234"
}
*/
// Test: LDTRH Wt, [Xn, #simm] - Load Register Halfword (unprivileged)
// Loads a halfword from memory with unprivileged access

.text
.global _start
_start:
    sub sp, sp, #16
    
    // Setup: store a halfword
    mov w0, #0x1234
    strh w0, [sp]
    
    // Clear register
    mov x0, #0
    
    // LDTRH: load halfword unprivileged
    ldtrh w0, [sp]
    
    brk #0
