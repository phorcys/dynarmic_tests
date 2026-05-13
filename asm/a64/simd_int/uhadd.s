/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000020000000200000000f00000008"
}
*/
// Test: UHADD Vd.4S, Vn.4S, Vm.4S - Unsigned Halving Add

.text
.global _start
_start:
    // v0.4s = [10, 20, 30, 40]
    mov w0, #10
    mov v0.s[0], w0
    mov w0, #20
    mov v0.s[1], w0
    mov w0, #30
    mov v0.s[2], w0
    mov w0, #40
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
    
    // UHADD: (v0 + v1) >> 1
    // (10 + 6) >> 1 = 8
    // (20 + 11) >> 1 = 15
    // (30 + 35) >> 1 = 32
    // (40 + 25) >> 1 = 32
    uhadd v0.4s, v0.4s, v1.4s
    
    brk #0
