/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000010000000080000000400000002",
    "Q1": "0x00000008000000040000000200000001"
  }
}
*/
// Test: USHR Vd.4S, Vn.4S, #imm - unsigned shift right by immediate

.text
.global _start
_start:
    // Load Q0 with [2, 4, 8, 16]
    mov w0, #2
    mov v0.s[0], w0
    mov w1, #4
    mov v0.s[1], w1
    mov w2, #8
    mov v0.s[2], w2
    mov w3, #16
    mov v0.s[3], w3
    
    // USHR: Q1 = Q0 >> 1
    // [2, 4, 8, 16] >> 1 = [1, 2, 4, 8]
    ushr v1.4s, v0.4s, #1

    brk #0
