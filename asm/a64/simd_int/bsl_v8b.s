/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xF0F0F0F0F0F0F0F0"
  }
}
*/
// Test: BSL - Bitwise Select (8B)

.text
.global _start
_start:
    // V0 = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}
    movz x8, #0xFFFF
    movk x8, #0xFFFF, lsl #16
    movk x8, #0xFFFF, lsl #32
    movk x8, #0xFFFF, lsl #48
    fmov d0, x8
    
    // V1 = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
    fmov d1, xzr
    
    // V2 = {0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0}
    movz x10, #0xF0F0
    movk x10, #0xF0F0, lsl #16
    movk x10, #0xF0F0, lsl #32
    movk x10, #0xF0F0, lsl #48
    fmov d2, x10
    
    // BSL: If V2 bit is 1, copy from V0, else copy from V1
    // V2 = 0xF0 = 1111 0000
    // Upper 4 bits (V2=1): copy from V0 (FF) -> 1111
    // Lower 4 bits (V2=0): copy from V1 (00) -> 0000
    // Result per byte: 1111 0000 = 0xF0
    bsl v2.8b, v0.8b, v1.8b
    
    fmov x0, d2

    brk #0
