/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000020000FFFF"
  }
}
*/
// Test: UXTL - Unsigned Extend Long (4S from 4H)

.text
.global _start
_start:
    // V0 = {0xFFFF, 0x0002} (16-bit unsigned: 65535, 2)
    movz x8, #0xFFFF
    movk x8, #0x0002, lsl #16
    fmov d0, x8
    
    // UXTL: zero extend each 16-bit to 32-bit
    uxtl v0.4s, v0.4h
    
    fmov x0, d0

    brk #0
