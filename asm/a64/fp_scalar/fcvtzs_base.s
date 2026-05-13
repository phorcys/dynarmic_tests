/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x40C80000",
    "X1": "0x0000000000000006",
    "D2": "0x401C000000000000",
    "X3": "0x0000000000000007",
    "X4": "0x0000000000000000"
  }
}
*/
// Test: FCVTZS - floating-point to signed integer (toward zero)
// S0 = 6.25, X1 = 6, D2 = 7.0, X3 = 7

.text
.global _start
_start:
    fmov s0, #6.25
    fcvtzs x1, s0
    
    fmov d2, #7.0
    fcvtzs x3, d2
    
    mov x4, #0
    brk #0
