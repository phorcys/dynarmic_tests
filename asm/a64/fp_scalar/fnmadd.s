/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFF8"
  }
}
*/
// Test: FNMADD - Fused Negate Multiply-Add

.text
.global _start
_start:
    // S0 = 2.0
    movz w8, #0x0000
    movk w8, #0x4000, lsl #16
    fmov s0, w8
    
    // S1 = 3.0
    movz w9, #0x0000
    movk w9, #0x4040, lsl #16
    fmov s1, w9
    
    // S2 = 2.0
    fmov s2, s0
    
    // FNMADD S0, S1, S2, S0 = -(S1 * S2) - S0 = -(3.0 * 2.0) - 2.0 = -6.0 - 2.0 = -8.0
    fnmadd s0, s1, s2, s0
    
    // Convert to integer for output
    fcvtzs x0, s0

    brk #0
