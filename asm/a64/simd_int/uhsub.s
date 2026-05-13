/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000025000000070000000400000002"
}
*/
// Test: UHSUB Vd.4S, Vn.4S, Vm.4S - Unsigned Halving Subtract

.text
.global _start
_start:
    // v0.4s = [10, 20, 50, 100]
    mov w0, #10
    mov v0.s[0], w0
    mov w0, #20
    mov v0.s[1], w0
    mov w0, #50
    mov v0.s[2], w0
    mov w0, #100
    mov v0.s[3], w0
    
    // v1.4s = [6, 11, 35, 25]
    mov w0, #6
    mov v1.s[0], w0
    mov w0, #11
    mov v1.s[1], w0
    mov w0, #35
    mov v1.s[2], w0
    mov w0, #25
    mov v1.s[3], w0
    
    // UHSUB: (v0 - v1) >> 1
    // (10 - 6) >> 1 = 2
    // (20 - 11) >> 1 = 4
    // (50 - 35) >> 1 = 7
    // (100 - 25) >> 1 = 37
    uhsub v0.4s, v0.4s, v1.4s
    
    brk #0
