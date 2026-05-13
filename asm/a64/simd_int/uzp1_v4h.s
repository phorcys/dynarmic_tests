/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0007000500030001"
  }
}
*/
// Test: UZP1 - Unzip vectors (primary, 4H)
// UZP1 extracts even elements: V0[0], V0[2], V1[0], V1[2]

.text
.global _start
_start:
    // V0 = {1, 2, 3, 4}
    movz x8, #0x0001
    movk x8, #0x0002, lsl #16
    movk x8, #0x0003, lsl #32
    movk x8, #0x0004, lsl #48
    fmov d0, x8
    
    // V1 = {5, 6, 7, 8}
    movz x9, #0x0005
    movk x9, #0x0006, lsl #16
    movk x9, #0x0007, lsl #32
    movk x9, #0x0008, lsl #48
    fmov d1, x9
    
    // UZP1: {1, 3, 5, 7} (even elements from each)
    uzp1 v0.4h, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
