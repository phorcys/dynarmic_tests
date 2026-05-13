/* CONFIG
{
  "Match": "All",
  "Q0": "0xfffffff60000000afffffffb00000008"
}
*/
// Test: SHADD Vd.4S, Vn.4S, Vm.4S - Signed Halving Add

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
    
    // v1.4s = [6, 10, -10, 20]
    mov w0, #6
    mov v1.s[0], w0
    mov w0, #10
    mov v1.s[1], w0
    mov w0, #0xFFFFFFF6  // -10
    mov v1.s[2], w0
    mov w0, #20
    mov v1.s[3], w0
    
    // SHADD: (v0 + v1) >> 1
    // (10 + 6) >> 1 = 8
    // (-20 + 10) >> 1 = -5
    // (30 + (-10)) >> 1 = 10
    // (-40 + 20) >> 1 = -10
    shadd v0.4s, v0.4s, v1.4s
    
    brk #0
