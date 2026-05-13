/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFF00FF00FF00FF00"
  }
}
*/
// Test: MOVI - Move Immediate (4H, shifted)

.text
.global _start
_start:
    // MOVI with shift: 0xFF shifted left by 8 = 0xFF00 in each halfword
    movi v0.4h, #0xFF, lsl #8
    
    fmov x0, d0

    brk #0
