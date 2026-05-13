/* CONFIG
{
  "Match": "All",
  "S0": "0x0000000040400000"
}
*/
// Test: FCSEL Sd, Sn, Sm, cond - Floating-point Conditional Select

.text
.global _start
_start:
    // S0 = 2.0, S1 = 3.0
    mov w0, #0x0000
    movk w0, #0x4000, lsl #16  // 2.0
    mov v0.s[0], w0
    mov w0, #0x0000
    movk w0, #0x4040, lsl #16  // 3.0
    mov v1.s[0], w0
    
    // Set condition flags: Z=1 (equal)
    mov x0, #1
    cmp x0, #1
    
    // FCSEL: if equal, S0 = S0, else S0 = S1
    fcsel s0, s0, s1, eq
    
    brk #0
