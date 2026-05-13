/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000000004000300020001",
    "Q1": "0x00000000000000000005000500050005",
    "Q2": "0x00000001000000010000000100000001",
    "Q3": "0x00000015000000100000000b00000006"
  }
}
*/
// Test: UMLAL Vd.4S, Vn.4H, Vm.4H - unsigned multiply-add long

.text
.global _start
_start:
    // Load D0 with halfwords: [1, 2, 3, 4]
    mov w0, #1
    mov w1, #2
    mov w2, #3
    mov w3, #4
    mov v0.h[0], w0
    mov v0.h[1], w1
    mov v0.h[2], w2
    mov v0.h[3], w3
    mov v0.d[1], xzr
    
    // Load D1 with halfwords: [5, 5, 5, 5]
    mov w4, #5
    dup v1.4h, w4
    mov v1.d[1], xzr
    
    // Load Q2 with initial accumulator: [1, 1, 1, 1]
    mov w5, #1
    dup v2.4s, w5
    
    // UMLAL: unsigned multiply-add long
    // Q3 = Q2 + D0 * D1 = [1+5, 1+10, 1+15, 1+20] = [6, 11, 16, 21]
    mov v3.16b, v2.16b
    umlal v3.4s, v0.4h, v1.4h

    brk #0
