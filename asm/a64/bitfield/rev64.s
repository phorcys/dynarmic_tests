/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x123456789ABCDEF0",
    "X1": "0xF0DEBC9A78563412"
  }
}
*/
// Test: REV64 Xd, Xn - Reverse bytes in 64-bit doublewords
// Reverses the byte order in the 64-bit register
// Alias: REV for 64-bit

.text
.global _start
_start:
    // Test with distinct bytes
    mov x0, #0xDEF0
    movk x0, #0x9ABC, lsl #16
    movk x0, #0x5678, lsl #32
    movk x0, #0x1234, lsl #48
    // X0 = 0x123456789ABCDEF0
    
    rev x1, x0
    // Full 64-bit reversal:
    // 0x123456789ABCDEF0 -> 0xF0DEBC9A78563412

    brk #0
