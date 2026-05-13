/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000003000000020000000100000000",
    "Q1": "0x00000006000000040000000200000000",
    "Q2": "0x00000012000000080000000200000000"
  }
}
*/
// Test: MUL.2D - 64-bit integer multiply (lower half only on ARM)
// Note: ARM doesn't have MUL.2D, use MUL.4S instead or check implementation

.text
.global _start
_start:
    // Load V0 with values [0, 1, 2, 3] as 32-bit
    mov x0, #0
    mov x1, #1
    mov x2, #2
    mov x3, #3
    mov v0.s[0], w0
    mov v0.s[1], w1
    mov v0.s[2], w2
    mov v0.s[3], w3
    
    // Load V1 with [0, 2, 4, 6]
    mov x0, #0
    mov x1, #2
    mov x2, #4
    mov x3, #6
    mov v1.s[0], w0
    mov v1.s[1], w1
    mov v1.s[2], w2
    mov v1.s[3], w3
    
    // MUL 32-bit
    mul v2.4s, v0.4s, v1.4s

    brk #0
