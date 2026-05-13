/* CONFIG
{
  "Match": "All",
  "VecData": {
    "V2": ["0x0000000500000001", "0x0000000700000003"]
  }
}
*/
// Test: TRN1 - Transpose vectors (interleave even elements)

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
    
    // V1 = [5, 6, 7, 8]
    mov w4, #5
    mov w5, #6
    mov w6, #7
    mov w7, #8
    ins v1.s[0], w4
    ins v1.s[1], w5
    ins v1.s[2], w6
    ins v1.s[3], w7
    
    // TRN1 V2.4S, V0.4S, V1.4S
    // Result: V2 = [v0[0], v1[0], v0[2], v1[2]] = [1, 5, 3, 7]
    trn1 v2.4s, v0.4s, v1.4s

    brk #0
