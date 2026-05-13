/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: CMEQ - Compare Equal (4S)

.text
.global _start
_start:
    // V0 = {5, 5}
    movz x8, #0x0005
    fmov d0, x8
    
    // V1 = {5, 5}
    movz x9, #0x0005
    fmov d1, x9
    
    // CMEQ: compare equal, result = all 1s if equal, 0 otherwise
    cmeq v0.4s, v0.4s, v1.4s
    
    fmov x0, d0

    brk #0
