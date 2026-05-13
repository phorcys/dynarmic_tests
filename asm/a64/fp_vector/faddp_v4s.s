/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x4000000040000000"
  }
}
*/
// Test: FADDP - Floating-point Add Pairwise (4S)

.text
.global _start
_start:
    // V0 = {1.0, 1.0, 1.0, 1.0}
    // 1.0 = 0x3F800000
    movz x8, #0x0000
    movk x8, #0x3F80, lsl #16
    movk x8, #0x0000, lsl #32
    movk x8, #0x3F80, lsl #48
    fmov d0, x8
    
    movz x9, #0x0000
    movk x9, #0x3F80, lsl #16
    movk x9, #0x0000, lsl #32
    movk x9, #0x3F80, lsl #48
    fmov v0.d[1], x9
    
    // FADDP: pairwise add
    // V0[0] = V0[0] + V0[1] = 1.0 + 1.0 = 2.0 = 0x40000000
    // V0[1] = V0[2] + V0[3] = 1.0 + 1.0 = 2.0 = 0x40000000
    faddp v0.4s, v0.4s, v0.4s
    
    // Get low 64 bits
    fmov x0, d0

    brk #0
