/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0F0F0F0F0F0F0F0F"
  }
}
*/
// Test: BIT - Bitwise Insert if True (8B)

.text
.global _start
_start:
    // V0 = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}
    movz x8, #0xFFFF
    movk x8, #0xFFFF, lsl #16
    movk x8, #0xFFFF, lsl #32
    movk x8, #0xFFFF, lsl #48
    fmov d0, x8
    
    // V1 = {0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F}
    movz x9, #0x0F0F
    movk x9, #0x0F0F, lsl #16
    movk x9, #0x0F0F, lsl #32
    movk x9, #0x0F0F, lsl #48
    fmov d1, x9
    
    // V2 = {0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F}
    movz x10, #0x0F0F
    movk x10, #0x0F0F, lsl #16
    movk x10, #0x0F0F, lsl #32
    movk x10, #0x0F0F, lsl #48
    fmov d2, x10
    
    // BIT: If V2 bit is 1, copy from V0, else keep V1
    // V2 = 0x0F = 0000 1111
    // Upper 4 bits (V2=0): keep V1 (0F) -> 0000
    // Lower 4 bits (V2=1): copy from V0 (FF) -> 1111
    // Result per byte: 0000 1111 = 0x0F
    bit v1.8b, v0.8b, v2.8b
    
    fmov x0, d1

    brk #0
