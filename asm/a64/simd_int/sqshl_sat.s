/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000080000000800000008000000080"
}
*/
// Test SQSHL vector saturate: a = [-76, -76, -76, -76], shift = [8, 8, 8, 8]
// Expected: [INT8_MIN, INT8_MIN, INT8_MIN, INT8_MIN] = [0x80, 0x80, 0x80, 0x80]

.text
.global _start
_start:
    // a = -76 in each byte
    mov w0, #180
    sub w0, w0, #256  // w0 = -76
    dup v0.16b, w0
    
    // shift = 8 in each byte
    mov w1, #8
    dup v1.16b, w1
    
    // SQSHL.16B
    sqshl v0.16b, v0.16b, v1.16b
    
    brk #0
