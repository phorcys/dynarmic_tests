/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0A09080706050403"
  }
}
*/
// Test: EXT - Extract vector from pair of vectors (8B)

.text
.global _start
_start:
    // V0 = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08}
    movz x8, #0x0201
    movk x8, #0x0403, lsl #16
    movk x8, #0x0605, lsl #32
    movk x8, #0x0807, lsl #48
    fmov d0, x8
    
    // V1 = {0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10}
    movz x9, #0x0A09
    movk x9, #0x0C0B, lsl #16
    movk x9, #0x0E0D, lsl #32
    movk x9, #0x100F, lsl #48
    fmov d1, x9
    
    // EXT V0, V0, V1, #2: Extract 8 bytes starting at index 2 from V0.V1 concatenated
    // Concatenated: {01,02,03,04,05,06,07,08,09,0A,0B,0C,0D,0E,0F,10}
    // Starting at index 2: {03,04,05,06,07,08,09,0A}
    ext v0.8b, v0.8b, v1.8b, #2
    
    fmov x0, d0

    brk #0
