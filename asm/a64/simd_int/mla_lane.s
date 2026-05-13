/* CONFIG
{
  "Match": "All",
  "VecData": {
    "V2": ["0x0000000400000003", "0x0000000800000007"]
  }
}
*/
// Test: MLA - Multiply-accumulate
// MLA Vd, Vn, Vm : Vd = Vd + (Vn * Vm)

.text
.global _start
_start:
    // V0 = [1, 2, 3, 4]
    mov w0, #1
    mov w1, #2
    mov w2, #3
    mov w3, #4
    ins v0.s[0], w0
    ins v0.s[1], w1
    ins v0.s[2], w2
    ins v0.s[3], w3
    
    // V1 = [2, 2, 2, 2]
    mov w4, #2
    ins v1.s[0], w4
    ins v1.s[1], w4
    ins v1.s[2], w4
    ins v1.s[3], w4
    
    // V2 = [1, 0, 1, 0] (accumulator)
    mov w5, #1
    ins v2.s[0], w5
    ins v2.s[1], wzr
    ins v2.s[2], w5
    ins v2.s[3], wzr
    
    // MLA V2.4S, V0.4S, V1.4S
    // V2 = V2 + V0 * V1
    // V2 = [1, 0, 1, 0] + [1, 2, 3, 4] * [2, 2, 2, 2]
    // V2 = [1, 0, 1, 0] + [2, 4, 6, 8] = [3, 4, 7, 8]
    mla v2.4s, v0.4s, v1.4s

    brk #0
