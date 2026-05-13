/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000300000003"
  }
}
*/
// Test: ABS - Absolute Value (4S)

.text
.global _start
_start:
    // V0 = {-3, 3}
    movz x8, #0xFFFD
    movk x8, #0xFFFF, lsl #16
    movk x8, #0x0003, lsl #32
    fmov d0, x8
    
    // ABS: |x|
    abs v0.4s, v0.4s
    
    fmov x0, d0

    brk #0
