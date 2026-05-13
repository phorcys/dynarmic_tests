/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: SMLAL Vd.2D, Vn.2S, Vm.2S - Signed Multiply Accumulate Long

.text
.global _start
_start:
    // v0.2d = [100, 200] (accumulator)
    mov x0, #100
    mov v0.d[0], x0
    mov x0, #200
    mov v0.d[1], x0
    
    // v1.2s = [10, -20]
    mov w0, #10
    mov v1.s[0], w0
    mov w0, #0xFFFFFFEC  // -20
    mov v1.s[1], w0
    
    // v2.2s = [5, 3]
    mov w0, #5
    mov v2.s[0], w0
    mov w0, #3
    mov v2.s[1], w0
    
    // SMLAL: v0 += v1 * v2 (sign-extended)
    // 100 + 10*5 = 150
    // 200 + (-20)*3 = 200 - 60 = 140
    smlal v0.2d, v1.2s, v2.2s
    
    brk #0