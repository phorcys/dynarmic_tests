/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: SBFX - Signed Bit Field Extract

.text
.global _start
_start:
    // x1 = 0x0000FFFF0000FFFF
    movz x1, #0xFFFF
    movk x1, #0x0000, lsl #16
    movk x1, #0xFFFF, lsl #32
    movk x1, #0x0000, lsl #48
    
    // SBFX: extract bits [15:0] from x1
    // 0xFFFF has sign bit set, so sign-extend to all 1s
    sbfx x0, x1, #0, #16

    brk #0
