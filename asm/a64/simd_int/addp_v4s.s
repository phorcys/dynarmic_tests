/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000060004"
  }
}
*/
// Test: ADDP - Add Pairwise (4S)

.text
.global _start
_start:
    // V0 = {1, 2, 3, 4}
    movz x8, #0x0001
    movk x8, #0x0002, lsl #16
    movk x8, #0x0003, lsl #32
    movk x8, #0x0004, lsl #48
    fmov d0, x8
    
    // ADDP: {1+2, 3+4} = {3, 7}
    addp v0.4s, v0.4s, v0.4s
    
    fmov x0, d0

    brk #0
