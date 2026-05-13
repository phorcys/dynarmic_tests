/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000000000000ffffffffffffffff"
}
*/
// Test: URSQRTE Vd.2S, Vn.2S - Unsigned Reciprocal Square Root Estimate

.text
.global _start
_start:
    // v0.2s = [4.0, 16.0] as integers (will be treated as fixed-point)
    // For URSQRTE, input is treated as fixed-point
    mov w0, #0x0004
    movk w0, #0x0010, lsl #16
    mov v0.s[0], w0
    mov v0.s[1], wzr
    
    // URSQRTE: unsigned reciprocal square root estimate
    ursqrte v0.2s, v0.2s
    
    brk #0
