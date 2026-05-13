/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000004000000030000000200000001",
    "Q1": "0x0000000000000000000000000000000a"
  }
}
*/
// Test: ADDV Vd.S, Vn.4S - add vector elements (reduce)

.text
.global _start
_start:
    // Load Q0 with [1, 2, 3, 4]
    mov w0, #1
    mov w1, #2
    mov w2, #3
    mov w3, #4
    mov v0.s[0], w0
    mov v0.s[1], w1
    mov v0.s[2], w2
    mov v0.s[3], w3
    
    // ADDV: sum all elements
    // Result = 1 + 2 + 3 + 4 = 10
    addv s1, v0.4s

    brk #0
