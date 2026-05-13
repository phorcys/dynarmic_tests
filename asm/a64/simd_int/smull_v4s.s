/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000006"
  }
}
*/
// Test: SMULL - Signed Multiply Long (4S from 4H)

.text
.global _start
_start:
    // V0 = {2, 2} (16-bit)
    movz x8, #0x0002
    fmov d0, x8
    
    // V1 = {3, 3} (16-bit)
    movz x9, #0x0003
    fmov d1, x9
    
    // SMULL: 2 * 3 = 6
    smull v0.4s, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
