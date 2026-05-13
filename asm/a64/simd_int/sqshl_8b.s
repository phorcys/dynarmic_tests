/* CONFIG
{
  "Match": "All",
  "D0": "0x8080808080808080"
}
*/
// Test SQSHL.8B: 8 elements of int8_t
// a = [-76, ...], shift = [8, ...]
// Expected: [0x80, ...] = [INT8_MIN, ...]

.text
.global _start
_start:
    // a = -76 in each byte (8 bytes in D0)
    mov w0, #180
    sub w0, w0, #256  // w0 = -76
    dup v0.8b, w0
    
    // shift = 8 in each byte
    mov w1, #8
    dup v1.8b, w1
    
    // SQSHL.8B (64-bit vector)
    sqshl v0.8b, v0.8b, v1.8b
    
    brk #0
