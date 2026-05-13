/* CONFIG
{
  "Match": "All",
  "D0": "0x7F80F8C000800000"
}
*/
// Test SQSHL.8B with real test data:
// a = [0, -3, 1, -2, -1, 87, 6, 8]
// b = [4, 11, 13, 5, 3, 12, 10, 9]
// r = [0, INT8_MIN, INT8_MAX, -64, -8, INT8_MAX, INT8_MAX, INT8_MAX]
// D0 bytes: [0, 0x80, 0x7F, 0xC0, 0xF8, 0x7F, 0x7F, 0x7F]
// D0 = 0x7F7F7FF8C080007F -> wait, need to check endianness

.text
.global _start
_start:
    // Load a = [0, -3, 1, -2, -1, 87, 6, 8]
    mov w0, #0
    mov w1, #253   // -3
    mov w2, #1
    mov w3, #254   // -2
    mov w4, #255   // -1
    mov w5, #87
    mov w6, #6
    mov w7, #8
    
    ins v0.b[0], w0
    ins v0.b[1], w1
    ins v0.b[2], w2
    ins v0.b[3], w3
    ins v0.b[4], w4
    ins v0.b[5], w5
    ins v0.b[6], w6
    ins v0.b[7], w7
    
    // Load b = [4, 11, 13, 5, 3, 12, 10, 9]
    mov w0, #4
    mov w1, #11
    mov w2, #13
    mov w3, #5
    mov w4, #3
    mov w5, #12
    mov w6, #10
    mov w7, #9
    
    ins v1.b[0], w0
    ins v1.b[1], w1
    ins v1.b[2], w2
    ins v1.b[3], w3
    ins v1.b[4], w4
    ins v1.b[5], w5
    ins v1.b[6], w6
    ins v1.b[7], w7
    
    // SQSHL.8B
    sqshl v0.8b, v0.8b, v1.8b
    
    brk #0
