/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005"
  }
}
*/
// Test: MLA - Multiply Accumulate (4S)

.text
.global _start
_start:
    // V0 = {2, 2} (accumulator)
    movz x8, #0x0002
    fmov d0, x8
    
    // V1 = {3, 3}
    movz x9, #0x0003
    fmov d1, x9
    
    // V2 = {1, 1}
    movz x10, #0x0001
    fmov d2, x10
    
    // MLA: V0 = V0 + V1 * V2 = 2 + 3*1 = 5
    mla v0.4s, v1.4s, v2.4s
    
    fmov x0, d0

    brk #0
