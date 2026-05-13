/* CONFIG
{
  "Match": "All",
  "S0": "0x000000003F800000"
}
*/
// Test: FMINNMV Sd, Vn.4S - Floating-point Minimum Number across Vector

.text
.global _start
_start:
    // v0.4s = [1.0, 5.0, 3.0, 2.0]
    mov w0, #0x0000
    movk w0, #0x3F80, lsl #16  // 1.0
    mov v0.s[0], w0
    mov w0, #0x0000
    movk w0, #0x40A0, lsl #16  // 5.0
    mov v0.s[1], w0
    mov w0, #0x0000
    movk w0, #0x4040, lsl #16  // 3.0
    mov v0.s[2], w0
    mov w0, #0x0000
    movk w0, #0x4000, lsl #16  // 2.0
    mov v0.s[3], w0
    
    // FMINNMV: min(1.0, 5.0, 3.0, 2.0) = 1.0
    fminnmv s0, v0.4s
    
    brk #0
