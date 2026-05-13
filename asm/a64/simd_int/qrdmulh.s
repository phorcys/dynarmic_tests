/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q2": "0x00000000000000000000000000000000"
  }
}
*/
// Test: QDMULH - Saturating doubling multiply high
// QDMULH returns high half of (2 * Vn * Vm), with saturation
// For small inputs (1,2,3,4) * 1, the doubled result fits in low bits
// So high half is 0

.text
.global _start
_start:
    // V0 = [1, 2, 3, 4] (4x 32-bit)
    mov w0, #1
    mov w1, #2
    mov w2, #3
    mov w3, #4
    ins v0.s[0], w0
    ins v0.s[1], w1
    ins v0.s[2], w2
    ins v0.s[3], w3
    
    // V1 = [1, 1, 1, 1]
    mov w4, #1
    ins v1.s[0], w4
    ins v1.s[1], w4
    ins v1.s[2], w4
    ins v1.s[3], w4
    
    // SQDMULH V2.4S, V0.4S, V1.4S
    // Result = high half of (2 * V0[i] * 1) = 0 for small values
    // 2*1*1=2, 2*2*1=4, 2*3*1=6, 2*4*1=8 - all fit in low bits
    sqdmulh v2.4s, v0.4s, v1.4s

    brk #0
