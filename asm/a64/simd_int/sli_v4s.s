/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000001000000010000000100000001",
    "Q1": "0x00000004000000030000000200000001",
    "Q2": "0x000000110000000d0000000900000005"
  }
}
*/
// Test: SLI Vd.4S, Vn.4S, #imm - shift left and insert

.text
.global _start
_start:
    // Load Q0 with destination value: [1, 1, 1, 1]
    mov w0, #1
    dup v0.4s, w0
    
    // Load Q1 with source value: [1, 2, 3, 4]
    mov w1, #1
    mov w2, #2
    mov w3, #3
    mov w4, #4
    mov v1.s[0], w1
    mov v1.s[1], w2
    mov v1.s[2], w3
    mov v1.s[3], w4
    
    // SLI: shift left by 2 and insert into Q0
    // (Vn << imm) | (Vd & ~mask)
    // Q1 << 2: [4, 8, 12, 16]
    // Result: [4|1, 8|1, 12|1, 16|1] = [5, 9, 13, 17]
    mov v2.16b, v0.16b
    sli v2.4s, v1.4s, #2

    brk #0
