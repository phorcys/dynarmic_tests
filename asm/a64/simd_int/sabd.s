/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000a000000050000000a00000005"
}
*/
// Test: SABD Vd.4S, Vn.4S, Vm.4S - Signed Absolute Difference

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
    
    // v1.4s = [15, -10, 25, -30]
    mov w0, #15
    mov v1.s[0], w0
    mov w0, #0xFFFFFFF6  // -10
    mov v1.s[1], w0
    mov w0, #25
    mov v1.s[2], w0
    mov w0, #0xFFFFFFE2  // -30
    mov v1.s[3], w0
    
    // SABD: |v0 - v1|
    // |10 - 15| = 5
    // |-20 - (-10)| = |-10| = 10
    // |30 - 25| = 5
    // |-40 - (-30)| = |-10| = 10
    sabd v0.4s, v0.4s, v1.4s
    
    brk #0
