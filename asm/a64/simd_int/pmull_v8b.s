/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000004"
  }
}
*/
// Test: PMULL - Polynomial Multiply (8B->16B, low half)

.text
.global _start
_start:
    // V0 = {0x02, 0x00, ...} 
    mov x8, #0x02
    fmov d0, x8
    
    // V1 = {0x02, 0x00, ...}
    mov x9, #0x02
    fmov d1, x9
    
    // PMULL: polynomial multiply
    // 0x02 * 0x02 in GF(2) = x * x = x^2 = 0x04
    pmull v0.8h, v0.8b, v1.8b
    
    // Get low 64 bits
    fmov x0, d0

    brk #0
