/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003"
  }
}
*/
// Test: FNEG - Floating-point Negate

.text
.global _start
_start:
    // Load -3.0 into S0
    movz w8, #0x0000
    movk w8, #0xC040, lsl #16
    fmov s0, w8
    
    // FNEG: negate(-3.0) = 3.0
    fneg s0, s0
    
    // Convert to integer
    fcvtzs x0, s0

    brk #0
