/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x40E0000040400000"
  }
}
*/
// Test: FADDP - Float Add Pairwise (vector)
// FADDP Vd.2S, Vn.2S, Vm.2S
// Pairwise: (Vn[0]+Vn[1], Vm[0]+Vm[1])
// V0 = {1.0, 2.0}, V1 = {3.0, 4.0}
// Result = {1.0+2.0, 3.0+4.0} = {3.0, 7.0}

.text
.global _start
_start:
    // V0 = {1.0, 2.0} = {0x3F800000, 0x40000000}
    movz x8, #0x0000
    movk x8, #0x3F80, lsl #16
    movk x8, #0x0000, lsl #32
    movk x8, #0x4000, lsl #48
    fmov d0, x8
    
    // V1 = {3.0, 4.0} = {0x40400000, 0x40800000}
    movz x9, #0x0000
    movk x9, #0x4040, lsl #16
    movk x9, #0x0000, lsl #32
    movk x9, #0x4080, lsl #48
    fmov d1, x9
    
    faddp v0.2s, v0.2s, v1.2s
    
    fmov x0, d0

    brk #0
