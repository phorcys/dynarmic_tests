/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFEFEFEFEFEFEFEFE"
  }
}
*/
// Test: MVN - Bitwise NOT (8B)

.text
.global _start
_start:
    // V0 = {0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01}
    movz x8, #0x0101
    movk x8, #0x0101, lsl #16
    movk x8, #0x0101, lsl #32
    movk x8, #0x0101, lsl #48
    fmov d0, x8
    
    // MVN: bitwise NOT
    // ~0x01 = 0xFE
    mvn v0.8b, v0.8b
    
    fmov x0, d0

    brk #0
