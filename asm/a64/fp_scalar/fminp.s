/* CONFIG
{
  "Match": "All",
  "S0": "0x000000003F800000"
}
*/
// Test: FMINP Sd, Vn.2S - Floating-point Minimum Pair

.text
.global _start
_start:
    // v0.2s = [1.0, 3.0]
    mov w0, #0x0000
    movk w0, #0x3F80, lsl #16  // 1.0
    mov v0.s[0], w0
    mov w0, #0x0000
    movk w0, #0x4040, lsl #16  // 3.0
    mov v0.s[1], w0
    
    // FMINP: min(1.0, 3.0) = 1.0
    fminp s0, v0.2s
    
    brk #0
