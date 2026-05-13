/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000FFFF"
  }
}
*/
// Test: EXTR - Extract Register (unsigned, using UBFX alias)

.text
.global _start
_start:
    // x1 = 0x0000FFFF0000FFFF
    movz x1, #0xFFFF
    movk x1, #0x0000, lsl #16
    movk x1, #0xFFFF, lsl #32
    movk x1, #0x0000, lsl #48
    
    // UBFX: extract bits [15:0] from x1, zero-extend
    ubfx x0, x1, #0, #16

    brk #0
