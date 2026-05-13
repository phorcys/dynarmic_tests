/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000004000000080000000200000004"
}
*/
// Test: SQDMULL Vd.4S, Vn.4H, Vm.4H - Signed Saturating Double Multiply Long
// Multiplies 16-bit values to 32-bit with doubling and saturation

.text
.global _start
_start:
    // Setup: v0.4h = [1, 2, 3, 4], v1.4h = [1, 2, 3, 4]
    mov w0, #1
    dup v0.4h, w0
    ins v0.h[1], w0
    add w0, w0, #1
    ins v0.h[1], w0
    add w0, w0, #1
    ins v0.h[2], w0
    add w0, w0, #1
    ins v0.h[3], w0
    
    mov w1, #1
    dup v1.4h, w1
    ins v1.h[1], w1
    add w1, w1, #1
    ins v1.h[1], w1
    add w1, w1, #1
    ins v1.h[2], w1
    add w1, w1, #1
    ins v1.h[3], w1
    
    // SQDMULL: signed saturating double multiply long
    // 2 * 1 * 2 = 4, 2 * 2 * 2 = 8, etc.
    sqdmull v0.4s, v0.4h, v1.4h
    
    brk #0
