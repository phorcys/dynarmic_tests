/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000002b00000021000000170000000d"
}
*/
// Test: URHADD Vd.4S, Vn.4S, Vm.4S - Unsigned Rounding Halving Add

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
    
    // v1.4s = [15, 25, 35, 45]
    mov w0, #15
    mov v1.s[0], w0
    mov w0, #25
    mov v1.s[1], w0
    mov w0, #35
    mov v1.s[2], w0
    mov w0, #45
    mov v1.s[3], w0
    
    // URHADD: (v0 + v1 + 1) >> 1
    // (10+15+1)>>1 = 26>>1 = 13
    // (20+25+1)>>1 = 46>>1 = 23
    // (30+35+1)>>1 = 66>>1 = 33
    // (40+45+1)>>1 = 86>>1 = 43
    urhadd v0.4s, v0.4s, v1.4s
    
    brk #0
