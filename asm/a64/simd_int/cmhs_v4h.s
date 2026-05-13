/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000FFFFFFFFFFFF"
  }
}
*/
// Test: CMHS - Compare Unsigned Higher or Same (vector, 4H)

.text
.global _start
_start:
    // V0 = {1, 2, 3, 4}
    movz x8, #0x0001
    movk x8, #0x0002, lsl #16
    movk x8, #0x0003, lsl #32
    movk x8, #0x0004, lsl #48
    fmov d0, x8
    
    // V1 = {0, 2, 3, 5}
    movz x9, #0x0000
    movk x9, #0x0002, lsl #16
    movk x9, #0x0003, lsl #32
    movk x9, #0x0005, lsl #48
    fmov d1, x9
    
    // CMHS: {1>=0, 2>=2, 3>=3, 4>=5} -> {FFFF, FFFF, FFFF, 0}
    cmhs v0.4h, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
