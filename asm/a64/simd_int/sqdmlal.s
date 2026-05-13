/* CONFIG
{
  "Match": "All",
  "Q0": "0x000000000000000A0000000000000002"
}
*/
// Test: SQDMLAL Vd.4S, Vn.4H, Vm.4H - Signed Saturating Doubling Multiply Accumulate Long
// Multiplies, doubles, and accumulates: Vd += Vn * Vm * 2

.text
.global _start
_start:
    // Setup: v0.4s = [1, 2, 0, 0]
    mov w0, #1
    dup v0.4s, w0
    mov w0, #2
    ins v0.s[1], w0
    
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
    
    // SQDMLAL: v0 += v1 * v2 * 2
    // v0[0] = 1 + 1*1*2 = 3, v0[1] = 2 + 2*2*2 = 10
    sqdmlal v0.4s, v1.4h, v2.4h
    
    brk #0
