/* CONFIG
{
  "Match": "All",
  "X0": "0xFFFFFFFFFFFF8000"
}
*/
// Test: LDTRSH Xt, [Xn] - Load Register Signed Halfword (unprivileged)

.text
.global _start
_start:
    // Store test data
    mov w0, #0x8000
    str w0, [sp, #-16]!
    
    // LDTRSH: load signed halfword from memory (unprivileged)
    ldtrsh x0, [sp]
    
    brk #0
