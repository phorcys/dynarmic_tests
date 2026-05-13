/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000100020003"
  }
}
*/
// Test: SUB - Vector Subtract (4H - 4x 16-bit)
// {4, 3, 2, 1} - {1, 1, 1, 1} = {3, 2, 1, 0}

.text
.global _start
_start:
    // V0 = {4, 3, 2, 1}
    movz x8, #0x0004
    movk x8, #0x0003, lsl #16
    movk x8, #0x0002, lsl #32
    movk x8, #0x0001, lsl #48
    fmov d0, x8
    
    // V1 = {1, 1, 1, 1}
    movz x9, #0x0001
    movk x9, #0x0001, lsl #16
    movk x9, #0x0001, lsl #32
    movk x9, #0x0001, lsl #48
    fmov d1, x9
    
    sub v0.4h, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
