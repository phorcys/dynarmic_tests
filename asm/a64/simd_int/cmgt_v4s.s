/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000FFFFFFFF"
  }
}
*/
// Test: CMGT - Compare Greater Than (signed, 4S)

.text
.global _start
_start:
    // V0 = {10, 10}
    movz x8, #0x000A
    fmov d0, x8
    
    // V1 = {5, 5}
    movz x9, #0x0005
    fmov d1, x9
    
    // CMGT: compare greater than (signed)
    cmgt v0.4s, v0.4s, v1.4s
    
    fmov x0, d0

    brk #0
