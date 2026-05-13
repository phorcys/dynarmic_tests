/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000001000000000000000000000000"
}
*/
// Test: URECPE Vd.4S, Vn.4S - Unsigned Reciprocal Estimate
// Computes approximate reciprocal of each 32-bit unsigned integer

.text
.global _start
_start:
    // v0 = [1, 2, 4, 8] as 32-bit unsigned integers
    mov w0, #1
    mov w1, #2
    mov w2, #4
    mov w3, #8
    mov v0.s[0], w0
    mov v0.s[1], w1
    mov v0.s[2], w2
    mov v0.s[3], w3
    
    // URECPE: approximate reciprocal
    // For input 1, output is approximately 2^32-1 (max)
    urecpe v0.4s, v0.4s
    
    brk #0
