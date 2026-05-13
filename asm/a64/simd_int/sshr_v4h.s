/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFCFFFCFFFC0004"
  }
}
*/
// Test: SSHR - Signed Shift Right (vector, 4H)

.text
.global _start
_start:
    // V0 = {16, -16, -16, -16} = {0x0010, 0xFFF0, 0xFFF0, 0xFFF0}
    movz x8, #0x0010
    movk x8, #0xFFF0, lsl #16
    movk x8, #0xFFF0, lsl #32
    movk x8, #0xFFF0, lsl #48
    fmov d0, x8
    
    // SSHR by 2: 16 >> 2 = 4, -16 >> 2 = -4
    sshr v0.4h, v0.4h, #2
    
    fmov x0, d0

    brk #0
