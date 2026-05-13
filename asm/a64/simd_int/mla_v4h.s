/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000C000900060003"
  }
}
*/
// Test: MLA - Multiply Accumulate (4H)

.text
.global _start
_start:
    // V0 = {1, 2, 3, 4}
    movz x8, #0x0001
    movk x8, #0x0002, lsl #16
    movk x8, #0x0003, lsl #32
    movk x8, #0x0004, lsl #48
    fmov d0, x8
    
    // V1 = {2, 2, 2, 2}
    movz x9, #0x0002
    movk x9, #0x0002, lsl #16
    movk x9, #0x0002, lsl #32
    movk x9, #0x0002, lsl #48
    fmov d1, x9
    
    // V2 = {1, 2, 3, 4}
    movz x10, #0x0001
    movk x10, #0x0002, lsl #16
    movk x10, #0x0003, lsl #32
    movk x10, #0x0004, lsl #48
    fmov d2, x10
    
    // MLA V0, V1, V2: V0 = V0 + V1 * V2
    // V0 = {1+2*1, 2+2*2, 3+2*3, 4+2*4} = {3, 6, 9, 12}
    // Result in little-endian: {3, 6, 9, 12} = 0x000C000900060003
    mla v0.4h, v1.4h, v2.4h
    
    fmov x0, d0

    brk #0
