/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000003c0000001e0000001e0000000d"
}
*/
// Test: UABA Vd.4S, Vn.4S, Vm.4S - Unsigned Absolute Difference and Accumulate

.text
.global _start
_start:
    // v0.4s = [10, 20, 30, 40] (accumulator)
    mov w0, #10
    mov v0.s[0], w0
    mov w0, #20
    mov v0.s[1], w0
    mov w0, #30
    mov v0.s[2], w0
    mov w0, #40
    mov v0.s[3], w0
    
    // v1.4s = [5, 25, 35, 30]
    mov w0, #5
    mov v1.s[0], w0
    mov w0, #25
    mov v1.s[1], w0
    mov w0, #35
    mov v1.s[2], w0
    mov w0, #30
    mov v1.s[3], w0
    
    // v2.4s = [8, 15, 35, 50]
    mov w0, #8
    mov v2.s[0], w0
    mov w0, #15
    mov v2.s[1], w0
    mov w0, #35
    mov v2.s[2], w0
    mov w0, #50
    mov v2.s[3], w0
    
    // UABA: v0 += |v1 - v2|
    // 10 + |5-8| = 10 + 3 = 13
    // 20 + |25-15| = 20 + 10 = 30
    // 30 + |35-35| = 30 + 0 = 30
    // 40 + |30-50| = 40 + 20 = 60
    uaba v0.4s, v1.4s, v2.4s
    
    brk #0
