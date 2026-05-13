/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000050002"
  }
}
*/
// Test: SMAXP - Maximum Pairwise (signed, 4S)

.text
.global _start
_start:
    // V0 = {1, 3, 2, 5}
    movz x8, #0x0001
    movk x8, #0x0003, lsl #16
    movk x8, #0x0002, lsl #32
    movk x8, #0x0005, lsl #48
    fmov d0, x8
    
    // SMAXP: max(1,3), max(2,5) = {3, 5}
    smaxp v0.4s, v0.4s, v0.4s
    
    fmov x0, d0

    brk #0
