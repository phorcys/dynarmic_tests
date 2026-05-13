/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000C"
  }
}
*/
// Test: UMULL - Unsigned Multiply Long (4S from 4H)

.text
.global _start
_start:
    // V0 = {3, 3} (16-bit)
    movz x8, #0x0003
    fmov d0, x8
    
    // V1 = {4, 4} (16-bit)
    movz x9, #0x0004
    fmov d1, x9
    
    // UMULL: 3 * 4 = 12
    umull v0.4s, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
