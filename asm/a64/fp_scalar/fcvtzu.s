/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003"
  }
}
*/
// Test: FCVTZU - Floating-point Convert to Unsigned Integer (toward zero)

.text
.global _start
_start:
    // Load 3.5 into S0
    movz w8, #0x0000
    movk w8, #0x4060, lsl #16
    fmov s0, w8
    
    // FCVTZU: convert 3.5 to unsigned integer (toward zero) = 3
    fcvtzu x0, s0

    brk #0
