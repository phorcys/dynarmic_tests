/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x1234567812345678",
    "X1": "0x3412785634127856"
  }
}
*/
// Test: REV16 Xd, Xn - Reverse bytes in 16-bit halfwords
// Reverses the byte order in each 16-bit halfword

.text
.global _start
_start:
    // Test with distinct bytes
    mov x0, #0x5678
    movk x0, #0x1234, lsl #16
    movk x0, #0x5678, lsl #32
    movk x0, #0x1234, lsl #48
    // X0 = 0x1234567812345678
    
    rev16 x1, x0
    // Each 16-bit halfword: 0x1234 -> 0x3412, 0x5678 -> 0x7856
    // X1 = 0x3412785634127856

    brk #0
