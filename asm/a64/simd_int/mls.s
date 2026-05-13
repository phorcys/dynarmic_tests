/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: MLS Vd.4S, Vn.4S, Vm.4S - Multiply Subtract

.text
.global _start
_start:
    // v0.4s = [100, 50, 30, 20] (accumulator)
    mov w0, #100
    mov v0.s[0], w0
    mov w0, #50
    mov v0.s[1], w0
    mov w0, #30
    mov v0.s[2], w0
    mov w0, #20
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
    
    // v2.4s = [10, 5, 2, 1]
    mov w0, #10
    mov v2.s[0], w0
    mov w0, #5
    mov v2.s[1], w0
    mov w0, #2
    mov v2.s[2], w0
    mov w0, #1
    mov v2.s[3], w0
    
    // MLS: v0 -= v1 * v2
    // 100 - 3*10 = 70
    // 50 - 5*5 = 25
    // 30 - 7*2 = 16
    // 20 - 9*1 = 11
    mls v0.4s, v1.4s, v2.4s
    
    brk #0
