/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFF000400030002"
  }
}
*/
// Test: UQADD - Unsigned Saturating Add (vector, 4H)

.text
.global _start
_start:
    // V0 = {1, 2, 3, 65535}
    movz x8, #0x0001
    movk x8, #0x0002, lsl #16
    movk x8, #0x0003, lsl #32
    movk x8, #0xFFFF, lsl #48
    fmov d0, x8
    
    // V1 = {1, 1, 1, 1}
    movz x9, #0x0001
    movk x9, #0x0001, lsl #16
    movk x9, #0x0001, lsl #32
    movk x9, #0x0001, lsl #48
    fmov d1, x9
    
    // UQADD: unsigned saturating add
    // 1+1=2, 2+1=3, 3+1=4, 65535+1=65535 (saturated)
    uqadd v0.4h, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
