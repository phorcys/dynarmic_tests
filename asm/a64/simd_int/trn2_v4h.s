/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0008000400060002"
  }
}
*/
// Test: TRN2 - Transpose vectors (secondary, 4H)
// TRN2: {V0[1], V0[3], V1[1], V1[3]}

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
    
    // TRN2: {2, 6, 4, 8} (elements at odd indices)
    trn2 v0.4h, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
