/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000004000000030000000200000001",
    "Q1": "0x00000010000000080000000400000002",
    "Q2": "0x0000000C000000070000000400000002"
  }
}
*/
// Test: SSRA Vd.4S, Vn.4S, #imm - signed shift right and accumulate

.text
.global _start
_start:
    // Load Q0 with [1, 2, 3, 4]
    mov w0, #1
    mov v0.s[0], w0
    mov w1, #2
    mov v0.s[1], w1
    mov w2, #3
    mov v0.s[2], w2
    mov w3, #4
    mov v0.s[3], w3
    
    // Load Q1 with [2, 4, 8, 16]
    mov w4, #2
    mov v1.s[0], w4
    mov w5, #4
    mov v1.s[1], w5
    mov w6, #8
    mov v1.s[2], w6
    mov w7, #16
    mov v1.s[3], w7
    
    // SSRA: Q2 = Q0 + (Q1 >> 1)
    // [1, 2, 3, 4] + ([2, 4, 8, 16] >> 1) = [1, 2, 3, 4] + [1, 2, 4, 8] = [2, 4, 7, 12]
    mov v2.16b, v0.16b
    ssra v2.4s, v1.4s, #1

    brk #0