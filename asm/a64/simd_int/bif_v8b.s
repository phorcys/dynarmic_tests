/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xF0F0F0F0F0F0F0F0"
  }
}
*/
// Test: BIF - Bitwise Insert if False (8B)

.text
.global _start
_start:
    // V0 = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}
    movz x8, #0xFFFF
    movk x8, #0xFFFF, lsl #16
    movk x8, #0xFFFF, lsl #32
    movk x8, #0xFFFF, lsl #48
    fmov d0, x8
    
    // V1 = {0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0}
    movz x9, #0xF0F0
    movk x9, #0xF0F0, lsl #16
    movk x9, #0xF0F0, lsl #32
    movk x9, #0xF0F0, lsl #48
    fmov d1, x9
    
    // V2 = {0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F}
    movz x10, #0x0F0F
    movk x10, #0x0F0F, lsl #16
    movk x10, #0x0F0F, lsl #32
    movk x10, #0x0F0F, lsl #48
    fmov d2, x10
    
    // BIF: for each bit, if V2 bit is 0, copy from V0, else keep V1
    // V2 = 0x0F (0000 1111)
    // If V2 bit = 0, result = V0 bit
    // If V2 bit = 1, result = V1 bit
    // Result: where V2 has 0 (upper 4 bits), take from V0 (1s) -> 1111
    //         where V2 has 1 (lower 4 bits), keep V1 (F0 has 0 in lower) -> 0000
    // Wait, let me reconsider
    // BIF: V1 = V1 ^ ((V1 ^ V0) & V2)
    // Actually BIF: If V2 bit is 0, copy from V0, else keep V1
    // So for V2 = 0x0F = 0000 1111:
    // Upper 4 bits (V2=0): copy from V0 (FF) -> 1111
    // Lower 4 bits (V2=1): keep V1 (F0) -> 0000
    // Result per byte: 1111 0000 = 0xF0
    bif v1.8b, v0.8b, v2.8b
    
    fmov x0, d1

    brk #0
