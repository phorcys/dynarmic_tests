/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000310000000000000031"
}
*/
// Test: PMULL Vd.8H, Vn.8B, Vm.8B - Polynomial Multiply Long
// Performs polynomial multiplication over GF(2), producing 16-bit results

.text
.global _start
_start:
    // Setup: v0.8b = [0x07, ...], v1.8b = [0x0B, ...]
    mov w0, #0x07  // x^2 + x + 1
    dup v0.8b, w0
    mov w0, #0x0B  // x^3 + x + 1
    dup v1.8b, w0
    
    // PMULL: polynomial multiply long (8B -> 8H)
    pmull v0.8h, v0.8b, v1.8b
    // Result: 0x31 in each halfword
    
    brk #0
