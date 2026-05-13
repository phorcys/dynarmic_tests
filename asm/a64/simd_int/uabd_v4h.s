/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0004000200020001"
  }
}
*/
// Test: UABD - Unsigned Absolute Difference (4H)

.text
.global _start
_start:
    // V0 = {1, 2, 3, 4}
    movz x8, #0x0001
    movk x8, #0x0002, lsl #16
    movk x8, #0x0003, lsl #32
    movk x8, #0x0004, lsl #48
    fmov d0, x8
    
    // V1 = {2, 4, 1, 8}
    movz x9, #0x0002
    movk x9, #0x0004, lsl #16
    movk x9, #0x0001, lsl #32
    movk x9, #0x0008, lsl #48
    fmov d1, x9
    
    // UABD: |V0 - V1| = {|1-2|, |2-4|, |3-1|, |4-8|} = {1, 2, 2, 4}
    uabd v0.4h, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
