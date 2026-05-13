/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000001234"
}
*/
// Test: LDR Xt, [Xn, #simm] - Load Register
// Loads a 64-bit value from memory

.text
.global _start
_start:
    sub sp, sp, #16
    
    // Setup: store a 64-bit value
    mov x0, #0x1234
    str x0, [sp]
    
    // Clear register
    mov x0, #0
    
    // LDR: load 64-bit value
    ldr x0, [sp]
    
    brk #0