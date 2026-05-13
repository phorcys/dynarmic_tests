/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000002"
  }
}
*/
// Test: UMULH Xd, Xn, Xm - Unsigned Multiply High
// Returns the high 64 bits of the 128-bit unsigned product

.text
.global _start
_start:
    // Test 1: 2^32 * 2^32 = 2^64
    // High 64 bits = 1
    mov x3, #1
    lsl x3, x3, #32   // x3 = 2^32
    umulh x4, x3, x3
    mov x0, x4  // X0 = 1
    
    // Test 2: 2^31 * 2^31 = 2^62
    // High 64 bits = 0 (fits in 63 bits)
    mov x5, #1
    lsl x5, x5, #31   // x5 = 2^31
    umulh x6, x5, x5
    mov x1, x6  // X1 = 0
    
    // Test 3: 2^32 * 2^33 = 2^65
    // High 64 bits = 2
    mov x7, #1
    lsl x7, x7, #33   // x7 = 2^33
    umulh x8, x3, x7   // x3 = 2^32, 2^32 * 2^33 = 2^65
    mov x2, x8  // X2 = 2

    brk #0
