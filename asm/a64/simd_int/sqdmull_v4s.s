/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000004"
  }
}
*/
// Test: SQDMULL - Signed Saturating Doubling Multiply Long (4S from 4H)

.text
.global _start
_start:
    // V0 = {1, 1} (16-bit)
    movz x8, #0x0001
    fmov d0, x8
    
    // V1 = {2, 2} (16-bit)
    movz x9, #0x0002
    fmov d1, x9
    
    // SQDMULL: 1 * 2 * 2 = 4 (doubled)
    sqdmull v0.4s, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
