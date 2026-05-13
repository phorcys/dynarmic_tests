/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000000000000ffffffff00000000"
}
*/
// Test: FCMLT Vd.4S, Vn.4S, #0.0 - Floating-point Compare Less than zero

.text
.global _start
_start:
    // v0.4s = [1.0, -1.0, 0.0, 2.0]
    mov w0, #0x0000
    movk w0, #0x3F80, lsl #16  // 1.0
    mov v0.s[0], w0
    mov w0, #0x0000
    movk w0, #0xBF80, lsl #16  // -1.0
    mov v0.s[1], w0
    mov w0, #0x0000  // 0.0
    mov v0.s[2], w0
    mov w0, #0x0000
    movk w0, #0x4000, lsl #16  // 2.0
    mov v0.s[3], w0
    
    // FCMLT v0.4s, v0.4s, #0.0 : v0 < 0.0 ?
    // 1.0 < 0.0 -> false -> all 0s
    // -1.0 < 0.0 -> true -> all 1s
    // 0.0 < 0.0 -> false -> all 0s
    // 2.0 < 0.0 -> false -> all 0s
    fcmlt v0.4s, v0.4s, #0.0
    
    brk #0