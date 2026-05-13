/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0008000600040002"
  }
}
*/
// Test: SMAXP - Signed Maximum Pairwise (4H)

.text
.global _start
_start:
    // V0 = {1, 2, 3, 4}
    movz x8, #0x0001
    movk x8, #0x0002, lsl #16
    movk x8, #0x0003, lsl #32
    movk x8, #0x0004, lsl #48
    fmov d0, x8
    
    // V1 = {5, 6, 7, 8}
    movz x9, #0x0005
    movk x9, #0x0006, lsl #16
    movk x9, #0x0007, lsl #32
    movk x9, #0x0008, lsl #48
    fmov d1, x9
    
    // SMAXP: pairwise max
    // V0[0] = max(V0[0], V0[1]) = max(1, 2) = 2
    // V0[1] = max(V0[2], V0[3]) = max(3, 4) = 4
    // V0[2] = max(V1[0], V1[1]) = max(5, 6) = 6
    // V0[3] = max(V1[2], V1[3]) = max(7, 8) = 8
    smaxp v0.4h, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
