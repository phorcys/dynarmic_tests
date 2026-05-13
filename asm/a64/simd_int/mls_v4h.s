/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFCFFFDFFFEFFFF"
  }
}
*/
// Test: MLS - Multiply Subtract (4H)

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
    
    // MLS V0, V1, V2: V0 = V0 - V1 * V2
    // V0 = {1-2*1, 2-2*2, 3-2*3, 4-2*4} = {-1, -2, -3, -4}
    // 16-bit: -1=0xFFFF, -2=0xFFFE, -3=0xFFFD, -4=0xFFFC
    // Result: 0xFFFCFFFDFFFEFFFF
    mls v0.4h, v1.4h, v2.4h
    
    fmov x0, d0

    brk #0
