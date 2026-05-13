/* CONFIG
{
  "Match": "All",
  "X0": "0xFFFFFFFF80000000"
}
*/
// Test: LDTRSW Xt, [Xn] - Load Register Signed Word (unprivileged)

.text
.global _start
_start:
    // Store test data (0x80000000 will be sign-extended)
    mov w0, #0x0000
    movk w0, #0x8000, lsl #16
    str w0, [sp, #-16]!
    
    // LDTRSW: load signed word from memory (unprivileged)
    ldtrsw x0, [sp]
    
    brk #0
