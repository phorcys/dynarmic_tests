/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000004"
  }
}
*/
// Test: UMOV Wd, Vn.S[index] - extract unsigned element from vector

.text
.global _start
_start:
    // Initialize Q0 with 1, 2, 3, 4
    mov w1, #1
    mov v0.s[0], w1
    mov w2, #2
    mov v0.s[1], w2
    mov w3, #3
    mov v0.s[2], w3
    mov w4, #4
    mov v0.s[3], w4
    
    // Extract element 3 (value 4) to x0
    umov w0, v0.s[3]

    brk #0
