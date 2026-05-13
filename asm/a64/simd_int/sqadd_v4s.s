/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x7FFFFFFF7FFFFFFF"
  }
}
*/
// Test: SQADD - Saturating Add (signed, 4S)

.text
.global _start
_start:
    // V0 = {0x7FFFFFFF, 0x7FFFFFFF} (max int32)
    movz x8, #0xFFFF
    movk x8, #0x7FFF, lsl #16
    movk x8, #0xFFFF, lsl #32
    movk x8, #0x7FFF, lsl #48
    fmov d0, x8
    
    // V1 = {0x00000001, 0x00000001}
    movz x9, #0x0001
    fmov d1, x9
    
    // SQADD: 0x7FFFFFFF + 1 = saturates to 0x7FFFFFFF
    sqadd v0.4s, v0.4s, v1.4s
    
    fmov x0, d0

    brk #0
