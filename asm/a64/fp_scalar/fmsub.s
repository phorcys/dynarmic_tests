/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFC"
  }
}
*/
// Test: FMSUB - Fused Multiply-Subtract

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
    
    // FMSUB S0, S1, S2, S0 = S0 - S1 * S2 = 2.0 - 3.0 * 2.0 = 2.0 - 6.0 = -4.0
    fmsub s0, s1, s2, s0
    
    // Convert to integer for output (truncate toward zero)
    fcvtzs x0, s0

    brk #0
