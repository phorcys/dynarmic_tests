/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40800000400000004080000040000000",
    "Q1": "0x3f8000003f8000003f8000003f800000",
    "Q2": "0xc000000000000000c000000000000000"
  }
}
*/
// Test: FRECPS Vd.4S, Vn.4S, Vm.4S - floating-point reciprocal step

.text
.global _start
_start:
    // Load Q0 with [2.0, 4.0, 2.0, 4.0]
    mov w0, #0x0000
    movk w0, #0x4000, lsl #16  // 2.0
    mov v0.s[0], w0
    mov v0.s[2], w0
    
    mov w1, #0x0000
    movk w1, #0x4080, lsl #16  // 4.0
    mov v0.s[1], w1
    mov v0.s[3], w1
    
    // Load Q1 with 1.0
    mov w2, #0x0000
    movk w2, #0x3f80, lsl #16  // 1.0
    dup v1.4s, w2
    
    // FRECPS: computes 2.0 - Vn * Vm for Newton-Raphson refinement
    frecps v2.4s, v0.4s, v1.4s

    brk #0
