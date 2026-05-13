/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0101010201010201"
  }
}
*/
// Test: CNT - Count Set Bits (8B)

.text
.global _start
_start:
    // V0 = {0x02, 0x03, 0x01, 0x01, 0x03, 0x02, 0x04, 0x08}
    movz x8, #0x0302
    movk x8, #0x0101, lsl #16
    movk x8, #0x0203, lsl #32
    movk x8, #0x0804, lsl #48
    fmov d0, x8
    
    // CNT: count set bits in each byte
    // 0x02 = 00000010 -> 1 bit
    // 0x03 = 00000011 -> 2 bits
    // 0x01 = 00000001 -> 1 bit
    // 0x01 = 00000001 -> 1 bit
    // 0x03 = 00000011 -> 2 bits
    // 0x02 = 00000010 -> 1 bit
    // 0x04 = 00000100 -> 1 bit
    // 0x08 = 00001000 -> 1 bit
    cnt v0.8b, v0.8b
    
    fmov x0, d0

    brk #0
