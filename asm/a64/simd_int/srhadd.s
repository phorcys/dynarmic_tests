/* CONFIG
{
  "Match": "All",
  "Q0": "0xfffffff70000000bfffffffc00000009"
}
*/
// Test: SRHADD Vd.4S, Vn.4S, Vm.4S - Signed Rounding Halving Add

.text
.global _start
_start:
    // v0.4s = [10, -20, 30, -40]
    mov w0, #10
    mov v0.s[0], w0
    mov w0, #0xFFFFFFEC  // -20
    mov v0.s[1], w0
    mov w0, #30
    mov v0.s[2], w0
    mov w0, #0xFFFFFFD8  // -40
    mov v0.s[3], w0
    
    // v1.4s = [7, 11, -9, 21]
    mov w0, #7
    mov v1.s[0], w0
    mov w0, #11
    mov v1.s[1], w0
    mov w0, #0xFFFFFFF7  // -9
    mov v1.s[2], w0
    mov w0, #21
    mov v1.s[3], w0
    
    // SRHADD: (v0 + v1 + 1) >> 1
    // (10 + 7 + 1) >> 1 = 9
    // (-20 + 11 + 1) >> 1 = -4
    // (30 + (-9) + 1) >> 1 = 11
    // (-40 + 21 + 1) >> 1 = -9
    srhadd v0.4s, v0.4s, v1.4s
    
    brk #0
