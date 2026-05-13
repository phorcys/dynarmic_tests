/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000FFFFFFFD"
  }
}
*/
// Test: NEG - Negate (4S)

.text
.global _start
_start:
    // V0 = {3, 3}
    movz x8, #0x0003
    fmov d0, x8
    
    // NEG: -3
    neg v0.4s, v0.4s
    
    fmov x0, d0

    brk #0
