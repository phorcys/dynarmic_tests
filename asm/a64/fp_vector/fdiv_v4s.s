/* CONFIG
{
  "Match": "All",
  "VecData": {
    "Q0": ["0x4000000040800000", "0x400000003F800000"]
  }
}
*/
// Test: FDIV - Float Divide (vector, 4S)
// {4.0, 2.0, 1.0, 2.0} / {1.0, 1.0, 1.0, 1.0} = {4.0, 2.0, 1.0, 2.0}

.text
.global _start
_start:
    // V0 = {4.0, 2.0, 1.0, 2.0}
    movz x8, #0x0000
    movk x8, #0x4080, lsl #16  // 4.0
    movk x8, #0x0000, lsl #32
    movk x8, #0x4000, lsl #48  // 2.0
    fmov d0, x8
    movz x8, #0x0000
    movk x8, #0x3F80, lsl #16  // 1.0
    movk x8, #0x0000, lsl #32
    movk x8, #0x4000, lsl #48  // 2.0
    ins v0.d[1], x8
    
    // V1 = {1.0, 1.0, 1.0, 1.0}
    movz x9, #0x0000
    movk x9, #0x3F80, lsl #16
    movk x9, #0x0000, lsl #32
    movk x9, #0x3F80, lsl #48
    fmov d1, x9
    ins v1.d[1], x9
    
    fdiv v0.4s, v0.4s, v1.4s

    brk #0
