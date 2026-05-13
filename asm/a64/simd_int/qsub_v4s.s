/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x80000000000000010000000100000001",
    "Q1": "0x00000001000000010000000100000001",
    "Q2": "0x80000000000000000000000000000000"
  }
}
*/
// Test: SQSUB Vd.4S, Vn.4S, Vm.4S - saturating subtract

.text
.global _start
_start:
    // Load Q0 with [1, 1, 1, 0x80000000]
    mov w0, #1
    mov w1, #1
    mov w2, #1
    mov w3, #0
    movk w3, #0x8000, lsl #16
    mov v0.s[0], w0
    mov v0.s[1], w1
    mov v0.s[2], w2
    mov v0.s[3], w3
    
    // Load Q1 with [1, 1, 1, 1]
    mov w4, #1
    dup v1.4s, w4
    
    // SQSUB: saturating signed subtract
    // [1-1, 1-1, 1-1, 0x80000000-1] -> [0, 0, 0, 0x80000000 (saturated)]
    sqsub v2.4s, v0.4s, v1.4s

    brk #0
