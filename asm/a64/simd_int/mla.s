/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: MLA Vd.4S, Vn.4S, Vm.4S - Multiply Accumulate

.text
.global _start
_start:
    // v0.4s = [2, 4, 6, 8] (accumulator)
    mov w0, #2
    mov v0.s[0], w0
    mov w0, #4
    mov v0.s[1], w0
    mov w0, #6
    mov v0.s[2], w0
    mov w0, #8
    mov v0.s[3], w0
    
    // v1.4s = [3, 5, 7, 9]
    mov w0, #3
    mov v1.s[0], w0
    mov w0, #5
    mov v1.s[1], w0
    mov w0, #7
    mov v1.s[2], w0
    mov w0, #9
    mov v1.s[3], w0
    
    // v2.4s = [2, 2, 2, 2]
    mov w0, #2
    dup v2.4s, w0
    
    // MLA: v0 += v1 * v2
    // 2 + 3*2 = 8
    // 4 + 5*2 = 14
    // 6 + 7*2 = 20
    // 8 + 9*2 = 26
    mla v0.4s, v1.4s, v2.4s
    
    brk #0
