/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFFFFFFFFFE0000000000000000"
}
*/
// Test: SQDMLSL Vd.4S, Vn.4H, Vm.4H - Signed Saturating Doubling Multiply Subtract Long
// Multiplies, doubles, and subtracts: Vd -= Vn * Vm * 2

.text
.global _start
_start:
    // Setup: v0.4s = [10, 20, 0, 0]
    mov w0, #10
    dup v0.4s, w0
    mov w0, #20
    ins v0.s[1], w0
    
    // v1.4h = [2, 3, 0, 0]
    mov w0, #2
    dup v1.4h, w0
    mov w0, #3
    ins v1.h[1], w0
    
    // v2.4h = [2, 3, 0, 0]
    mov v2.16b, v1.16b
    
    // SQDMLSL: v0 -= v1 * v2 * 2
    // v0[0] = 10 - 2*2*2 = 2, v0[1] = 20 - 3*3*2 = 2
    sqdmlsl v0.4s, v1.4h, v2.4h
    
    brk #0
