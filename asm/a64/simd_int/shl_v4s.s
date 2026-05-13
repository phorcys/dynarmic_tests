/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000004000000030000000200000001",
    "Q1": "0x000000100000000C0000000800000004"
  }
}
*/
// Test: SHL Vd.4S, Vn.4S, #imm - shift left by immediate

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
    
    // SHL: Q1 = Q0 << 2
    // [1, 2, 3, 4] << 2 = [4, 8, 12, 16]
    shl v1.4s, v0.4s, #2

    brk #0
