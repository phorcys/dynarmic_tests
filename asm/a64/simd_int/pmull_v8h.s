/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000000000000004030201",
    "Q1": "0x00000000000000000505050505050505",
    "Q2": "0x00000000000000000014000f000a0005"
  }
}
*/
// Test: PMULL Vd.8H, Vn.8B, Vm.8B - polynomial multiply long

.text
.global _start
_start:
    // Load D0 with bytes: [1, 2, 3, 4, ...]
    mov w0, #1
    mov w1, #2
    mov w2, #3
    mov w3, #4
    mov v0.b[0], w0
    mov v0.b[1], w1
    mov v0.b[2], w2
    mov v0.b[3], w3
    mov v0.d[1], xzr
    
    // Load D1 with bytes: [5, 5, 5, 5, ...]
    mov w4, #5
    dup v1.8b, w4
    mov v1.d[1], xzr
    
    // PMULL: polynomial multiply (each byte -> halfword)
    // This is a carry-less multiplication in GF(2^8)
    // 1*5=5, 2*5=10, 3*5=15, 4*5=20 in polynomial arithmetic
    pmull v2.8h, v0.8b, v1.8b

    brk #0
