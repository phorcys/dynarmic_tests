/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000069"
}
*/
// Test: PMUL Vd.16B, Vn.16B, Vm.16B - Polynomial Multiply
// Performs polynomial multiplication over GF(2)

.text
.global _start
_start:
    // Setup: v0.16b = [0x07, ...], v1.16b = [0x0B, ...]
    // Polynomial multiply: (x^2 + x + 1) * (x^3 + x + 1) = x^5 + x^4 + 1 = 0x31
    mov w0, #0x07  // 0b00000111 = x^2 + x + 1
    dup v0.16b, w0
    mov w0, #0x0B  // 0b00001011 = x^3 + x + 1
    dup v1.16b, w0
    
    // PMUL: polynomial multiply
    pmul v0.16b, v0.16b, v1.16b
    // Result: 0x31 * 16 bytes
    
    brk #0
