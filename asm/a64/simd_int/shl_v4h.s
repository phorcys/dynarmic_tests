/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0040003000200010"
  }
}
*/
// Test: SHL - Shift Left (vector, 4H)

.text
.global _start
_start:
    // V0 = {1, 2, 3, 4}
    movz x8, #0x0001
    movk x8, #0x0002, lsl #16
    movk x8, #0x0003, lsl #32
    movk x8, #0x0004, lsl #48
    fmov d0, x8
    
    // SHL by 4: 1<<4=16, 2<<4=32, 3<<4=48, 4<<4=64
    shl v0.4h, v0.4h, #4
    
    fmov x0, d0

    brk #0
