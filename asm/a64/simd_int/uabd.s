/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000f000000050000000a00000005"
}
*/
// Test: UABD Vd.4S, Vn.4S, Vm.4S - Unsigned Absolute Difference

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
    
    // v1.4s = [15, 10, 35, 25]
    mov w0, #15
    mov v1.s[0], w0
    mov w0, #10
    mov v1.s[1], w0
    mov w0, #35
    mov v1.s[2], w0
    mov w0, #25
    mov v1.s[3], w0
    
    // UABD: |v0 - v1|
    // |10-15| = 5
    // |20-10| = 10
    // |30-35| = 5
    // |40-25| = 15
    uabd v0.4s, v0.4s, v1.4s
    
    brk #0
