/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x7fffffff000000010000000100000000",
    "Q1": "0x00000001000000010000000100000001",
    "Q2": "0x7fffffff000000020000000200000001"
  }
}
*/
// Test: SQADD Vd.4S, Vn.4S, Vm.4S - saturating add

.text
.global _start
_start:
    // Load Q0 with [0, 1, 1, 0x7fffffff]
    mov w0, #0
    mov w1, #1
    mov w2, #1
    mov w3, #0xffff
    movk w3, #0x7fff, lsl #16
    mov v0.s[0], w0
    mov v0.s[1], w1
    mov v0.s[2], w2
    mov v0.s[3], w3
    
    // Load Q1 with [1, 1, 1, 1]
    mov w4, #1
    dup v1.4s, w4
    
    // SQADD: saturating signed add
    // [0+1, 1+1, 1+1, 0x7fffffff+1] -> [1, 2, 2, 0x7fffffff (saturated)]
    sqadd v2.4s, v0.4s, v1.4s

    brk #0
