/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// Test: MLS - Multiply Subtract (4S)

.text
.global _start
_start:
    // V0 = {10, 10} (accumulator)
    movz x8, #0x000A
    fmov d0, x8
    
    // V1 = {3, 3}
    movz x9, #0x0003
    fmov d1, x9
    
    // V2 = {3, 3}
    movz x10, #0x0003
    fmov d2, x10
    
    // MLS: V0 = V0 - V1 * V2 = 10 - 3*3 = 1
    mls v0.4s, v1.4s, v2.4s
    
    fmov x0, d0

    brk #0
