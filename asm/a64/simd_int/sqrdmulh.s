/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000100000000000000002"
}
*/
// Test: SQRDMULH Vd.4H, Vn.4H, Vm.4H - Signed Saturating Rounding Doubling Multiply Returning High Half
// Multiplies, doubles, rounds, and returns high half

.text
.global _start
_start:
    // v1.4h = [1000, 2000, 3000, 4000]
    mov w0, #1000
    dup v1.4h, w0
    mov w0, #2000
    ins v1.h[1], w0
    mov w0, #3000
    ins v1.h[2], w0
    mov w0, #4000
    ins v1.h[3], w0
    
    // v2.4h = [100, 200, 300, 400]
    mov w0, #100
    dup v2.4h, w0
    mov w0, #200
    ins v2.h[1], w0
    mov w0, #300
    ins v2.h[2], w0
    mov w0, #400
    ins v2.h[3], w0
    
    // SQRDMULH: returns high half of (v1 * v2 * 2) with rounding
    sqrdmulh v0.4h, v1.4h, v2.4h
    
    brk #0
