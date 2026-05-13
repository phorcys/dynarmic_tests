/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000001"
}
*/
// Test: UMULH Xd, Xn, Xm - Unsigned Multiply High
// Multiplies two 64-bit values, returns high 64 bits of 128-bit result

.text
.global _start
_start:
    // x0 = 0x100000000 (2^32)
    // x1 = 0x100000000 (2^32)
    // UMULH: x0 * x1 = 2^64, high 64 bits = 1
    mov x0, #0
    movk x0, #1, lsl #32
    mov x1, #0
    movk x1, #1, lsl #32
    
    umulh x0, x0, x1
    
    brk #0
