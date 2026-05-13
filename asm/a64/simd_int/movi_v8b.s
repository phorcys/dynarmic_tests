/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0505050505050505"
  }
}
*/
// Test: MOVI - Move Immediate (8B)

.text
.global _start
_start:
    // MOVI: broadcast immediate to all bytes
    movi v0.8b, #5
    
    fmov x0, d0

    brk #0
