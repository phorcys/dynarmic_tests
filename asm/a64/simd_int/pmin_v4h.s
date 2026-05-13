/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0007000500030001"
  }
}
*/
// Test: SMINP - Signed Minimum Pairwise (4H)

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
    
    // SMINP: pairwise min
    // V0[0] = min(V0[0], V0[1]) = min(1, 2) = 1
    // V0[1] = min(V0[2], V0[3]) = min(3, 4) = 3
    // V0[2] = min(V1[0], V1[1]) = min(5, 6) = 5
    // V0[3] = min(V1[2], V1[3]) = min(7, 8) = 7
    sminp v0.4h, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
