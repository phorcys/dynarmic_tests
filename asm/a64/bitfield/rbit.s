/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFF0000FFFF0000FF",
    "X1": "0xFF0000FFFF0000FF"
  }
}
*/
// Test: RBIT Xd, Xn - Reverse Bits
// Reverses the bit order in a register

.text
.global _start
_start:
    // Test with alternating bits pattern
    mov x0, #0xFF
    movk x0, #0xFF00, lsl #16
    movk x0, #0xFF, lsl #32
    movk x0, #0xFF00, lsl #48
    // X0 = 0xFF00FF00FF00FF00
    
    rbit x1, x0
    // X1 = bit-reversed X0
    // 0xFF00FF00FF00FF00 reversed = 0xFF0000FFFF0000FF

    brk #0