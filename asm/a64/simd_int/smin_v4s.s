/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000005000000030000000200000001",
    "Q1": "0x00000004000000040000000400000004",
    "Q2": "0x00000004000000030000000200000001"
  }
}
*/
// Test: SMIN Vd.4S, Vn.4S, Vm.4S - signed minimum

.text
.global _start
_start:
    // Load Q0 with [1, 2, 3, 5]
    mov w0, #1
    mov w1, #2
    mov w2, #3
    mov w3, #5
    mov v0.s[0], w0
    mov v0.s[1], w1
    mov v0.s[2], w2
    mov v0.s[3], w3
    
    // Load Q1 with [4, 4, 4, 4]
    mov w4, #4
    dup v1.4s, w4
    
    // SMIN: signed minimum
    // [min(1,4), min(2,4), min(3,4), min(5,4)] = [1, 2, 3, 4]
    smin v2.4s, v0.4s, v1.4s

    brk #0
