/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000004000000030000000200000001",
    "Q1": "0x00000000000000000000000000000000"
  }
}
*/
// Test: CMEQ Vd.4S, Vn.4S, #0 - compare equal to zero

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
    
    // CMEQ with #0: Q1 = (Q0 == 0)
    // [1, 2, 3, 4] == 0 = [0, 0, 0, 0]
    cmeq v1.4s, v0.4s, #0

    brk #0
