/* CONFIG
{
  "Match": "All",
  "X0": "0xFFFFFFFFFFFFFFFF"
}
*/
// Test: LDTRSB Xt, [Xn] - Load Register Signed Byte (unprivileged)

.text
.global _start
_start:
    // Store test data
    mov w0, #0x12FF
    str w0, [sp, #-16]!
    
    // LDTRSB: load signed byte from memory (unprivileged)
    ldtrsb x0, [sp]
    
    brk #0
