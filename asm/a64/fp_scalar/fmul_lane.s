/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40800000408000004080000040800000",
    "D1": "0x0000000040A00000",
    "Q2": "0x41A0000041A0000041A0000041A00000"
  }
}
*/
// Test: FMUL Vd.4S, Vn.4S, Vm.S[] - multiply by element

.text
.global _start
_start:
    // Load Q0 with 4.0
    mov w0, #0x0000
    movk w0, #0x4080, lsl #16
    dup v0.4s, w0
    
    // Load D1 with 5.0
    mov w1, #0x0000
    movk w1, #0x40A0, lsl #16
    mov v1.s[0], w1
    
    // FMUL: Q2 = Q0 * v1.s[0]
    // 4.0 * 5.0 = 20.0
    fmul v2.4s, v0.4s, v1.s[0]

    brk #0
