/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000001000000000000000000000000"
}
*/
// Test: SQNEG Vd.4H, Vn.4H - Signed Saturating Negate
// Negates with saturation to prevent overflow

.text
.global _start
_start:
    // Setup: create vector with values
    // V0.4H = [1, 0, -1, 0x8000] (0x8000 = -32768, negate would overflow)
    mov w0, #1
    mov v0.h[0], w0
    mov w0, #0
    mov v0.h[1], w0
    mov w0, #0xFFFF        // -1 in 16-bit signed
    mov v0.h[2], w0
    mov w0, #0x8000        // -32768 in 16-bit signed
    mov v0.h[3], w0
    
    // SQNEG: Saturating negate
    // 1 -> -1
    // 0 -> 0
    // -1 -> 1
    // -32768 -> 32767 (saturated, because 32768 would overflow)
    sqneg v0.4h, v0.4h
    
    // V0.4H = [-1, 0, 1, 32767]
    // Q0 = 0x00007FFF0000000100000000FFFFFFFF
    // Wait, -1 in 16-bit is 0xFFFF, so:
    // Q0 = 0x00007FFF0000000100000000FFFFFFFF

    brk #0
