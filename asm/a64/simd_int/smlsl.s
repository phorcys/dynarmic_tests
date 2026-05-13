/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: SMLSL Vd.2D, Vn.2S, Vm.2S - Signed Multiply Subtract Long

.text
.global _start
_start:
    // v0.2d = [1000, 500] (accumulator)
    mov x0, #1000
    mov v0.d[0], x0
    mov x0, #500
    mov v0.d[1], x0
    
    // v1.2s = [10, 20]
    mov w0, #10
    mov v1.s[0], w0
    mov w0, #20
    mov v1.s[1], w0
    
    // v2.2s = [5, 3]
    mov w0, #5
    mov v2.s[0], w0
    mov w0, #3
    mov v2.s[1], w0
    
    // SMLSL: v0 -= v1 * v2 (sign-extended)
    // 1000 - 10*5 = 950
    // 500 - 20*3 = 440
    smlsl v0.2d, v1.2s, v2.2s
    
    brk #0