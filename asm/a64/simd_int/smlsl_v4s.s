/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000004"
  }
}
*/
// Test: SMLSL - Signed Multiply Subtract Long (4S from 4H)

.text
.global _start
_start:
    // V0 = {10, 10} (accumulator, 32-bit)
    movz x8, #0x000A
    fmov d0, x8
    
    // V1 = {3, 3} (16-bit)
    movz x9, #0x0003
    fmov d1, x9
    
    // V2 = {2, 2} (16-bit)
    movz x10, #0x0002
    fmov d2, x10
    
    // SMLSL: V0 = V0 - V1 * V2 = 10 - 3*2 = 4
    smlsl v0.4s, v1.4h, v2.4h
    
    fmov x0, d0

    brk #0
