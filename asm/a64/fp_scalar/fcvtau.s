/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000002",
    "X3": "0x0000000000000035",
    "X4": "0x0000000000000035"
  }
}
*/
// Test: FCVTAU - Float Convert to unsigned integer, round to nearest with ties to away

.text
.global _start
_start:
    // Load 1.5 into S0
    movz x8, #0x0000, lsl #0
    movk x8, #0x3FC0, lsl #16
    fmov s0, w8
    fcvtau x0, s0
    
    // Load 1.4 into S1
    movz x9, #0x3333, lsl #0
    movk x9, #0x3FB3, lsl #16
    fmov s1, w9
    fcvtau x1, s1
    
    // Load 1.8 into S2
    movz x10, #0x6666, lsl #0
    movk x10, #0x3FE6, lsl #16
    fmov s2, w10
    fcvtau x2, s2

    // Load 52.5 into S3. Tie-away should round to 53, not 52.
    movz x11, #0x0000, lsl #0
    movk x11, #0x4252, lsl #16
    fmov s3, w11
    fcvtau x3, s3

    // Load 52.5 into D4. Tie-away should round to 53.
    movz x12, #0x0000, lsl #0
    movk x12, #0x0000, lsl #16
    movk x12, #0x4000, lsl #32
    movk x12, #0x404A, lsl #48
    fmov d4, x12
    fcvtau x4, d4

    brk #0
