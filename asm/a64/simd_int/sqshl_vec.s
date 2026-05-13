/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000100000000000000010"
}
*/
// Test SQSHL vector: a = [2, 2, 2, 2], shift = [3, 3, 3, 3]
// Expected: [16, 16, 16, 16]

.text
.global _start
_start:
    mov w0, #2
    dup v0.4s, w0
    mov w1, #3
    dup v1.4s, w1
    
    sqshl v0.4s, v0.4s, v1.4s
    
    brk #0
