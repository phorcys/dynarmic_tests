/* CONFIG
{
  "Match": "All",
  "Q0": "0x3FF00000000000003FF0000000000000"
}
*/
// Test: FCVTN2 Vd.2S, Vn.2D - Floating-point Convert Narrow (high half)
// Converts double to single, storing in upper half

.text
.global _start
_start:
    // Setup: v0.2d = [1.0, 2.0]
    fmov d0, #1.0
    fmov d1, #2.0
    ins v0.d[0], x0
    ins v0.d[1], x1
    
    // Clear output
    movi v2.4s, #0
    
    // FCVTN2: convert double to single, store in upper half
    fcvtn2 v2.4s, v0.2d
    
    // Copy result
    mov v0.16b, v2.16b
    
    brk #0
