/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0004000400040004"
  }
}
*/
// Test: USHR - Unsigned Shift Right (vector, 4H)

.text
.global _start
_start:
    // V0 = {16, 16, 16, 16}
    movz x8, #0x0010
    movk x8, #0x0010, lsl #16
    movk x8, #0x0010, lsl #32
    movk x8, #0x0010, lsl #48
    fmov d0, x8
    
    // USHR by 2: 16 >> 2 = 4
    ushr v0.4h, v0.4h, #2
    
    fmov x0, d0

    brk #0
