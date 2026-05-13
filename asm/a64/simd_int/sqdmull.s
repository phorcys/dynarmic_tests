/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000080000000000000002"
}
*/
// Test: SQDMULL Vd.4S, Vn.4H, Vm.4H - Signed Saturating Doubling Multiply Long
// Multiplies and doubles: Vd = Vn * Vm * 2

.text
.global _start
_start:
    // v1.4h = [1, 2, 3, 4]
    mov w0, #1
    dup v1.4h, w0
    mov w0, #2
    ins v1.h[1], w0
    mov w0, #3
    ins v1.h[2], w0
    mov w0, #4
    ins v1.h[3], w0
    
    // v2.4h = [1, 2, 3, 4]
    mov v2.16b, v1.16b
    
    // SQDMULL: v0 = v1 * v2 * 2
    // v0[0] = 1*1*2 = 2, v0[1] = 2*2*2 = 8
    sqdmull v0.4s, v1.4h, v2.4h
    
    brk #0
