/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x4040000040000000"
  }
}
*/
// Test: FMLA - Float Multiply-Add (vector, 2S)
// Vd = Vd + Vn * Vm
// {1.0, 1.0} + {1.0, 2.0} * {1.0, 1.0} = {2.0, 3.0}

.text
.global _start
_start:
    // V0 = {1.0, 1.0} (accumulator)
    movz x8, #0x0000
    movk x8, #0x3F80, lsl #16
    movk x8, #0x0000, lsl #32
    movk x8, #0x3F80, lsl #48
    fmov d0, x8
    
    // V1 = {1.0, 2.0} (multiplicand)
    movz x9, #0x0000
    movk x9, #0x3F80, lsl #16
    movk x9, #0x0000, lsl #32
    movk x9, #0x4000, lsl #48
    fmov d1, x9
    
    // V2 = {1.0, 1.0} (multiplier)
    movz x10, #0x0000
    movk x10, #0x3F80, lsl #16
    movk x10, #0x0000, lsl #32
    movk x10, #0x3F80, lsl #48
    fmov d2, x10
    
    fmla v0.2s, v1.2s, v2.2s
    
    fmov x0, d0

    brk #0
