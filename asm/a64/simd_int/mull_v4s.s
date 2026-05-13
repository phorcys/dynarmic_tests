/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000000004000300020001",
    "Q1": "0x00000000000000000005000500050005",
    "Q2": "0x000000140000000f0000000a00000005"
  }
}
*/
// Test: UMULL Vd.4S, Vn.4H, Vm.4H - unsigned multiply long

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
    
    // UMULL: unsigned multiply long (halfword -> word)
    // [1*5, 2*5, 3*5, 4*5] = [5, 10, 15, 20]
    umull v2.4s, v0.4h, v1.4h

    brk #0
