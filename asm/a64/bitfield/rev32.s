/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x123456789ABCDEF0",
    "X1": "0x78563412F0DEBC9A"
  }
}
*/
// Test: REV32 Xd, Xn - Reverse bytes in 32-bit words
// Reverses the byte order in each 32-bit word

.text
.global _start
_start:
    // Test with distinct bytes
    mov x0, #0xDEF0
    movk x0, #0x9ABC, lsl #16
    movk x0, #0x5678, lsl #32
    movk x0, #0x1234, lsl #48
    // X0 = 0x123456789ABCDEF0
    
    rev32 x1, x0
    // Each 32-bit word reversed:
    // 0x12345678 -> 0x78563412
    // 0x9ABCDEF0 -> 0xF0DEBC9A
    // X1 = 0x78563412F0DEBC9A

    brk #0
