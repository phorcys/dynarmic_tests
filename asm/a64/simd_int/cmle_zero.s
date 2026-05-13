/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000001FFFFFFFEFFFFFFFF00000000",
    "Q1": "0x00000000FFFFFFFFFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: CMLE Vd.4S, Vn.4S, #0 - compare less than or equal to zero

.text
.global _start
_start:
    // Load Q0 with [0, -1, -2, 1]
    mov w0, #0
    mov v0.s[0], w0
    mov w1, #-1
    mov v0.s[1], w1
    mov w2, #-2
    mov v0.s[2], w2
    mov w3, #1
    mov v0.s[3], w3
    
    // CMLE with #0: Q1 = (Q0 <= 0)
    // [0, -1, -2, 1] <= 0 = [1, 1, 1, 0]
    cmle v1.4s, v0.4s, #0

    brk #0
