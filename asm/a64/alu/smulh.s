/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000000",
    "X2": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: SMULH Xd, Xn, Xm - Signed Multiply High
// Returns the high 64 bits of the 128-bit signed product

.text
.global _start
_start:
    // Test 1: 2^32 * 2^32 = 2^64
    // High 64 bits = 1
    mov x3, #1
    lsl x3, x3, #32   // x3 = 2^32
    smulh x4, x3, x3
    mov x0, x4  // X0 = 1
    
    // Test 2: 2^31 * 2^31 = 2^62
    // High 64 bits = 0 (fits in 63 bits, positive)
    mov x5, #1
    lsl x5, x5, #31   // x5 = 2^31
    smulh x6, x5, x5
    mov x1, x6  // X1 = 0
    
    // Test 3: -1 * 2
    // -1 * 2 = -2 in signed
    // 128-bit signed -2: high = -1, low = -2
    mov x7, #-1
    mov x8, #2
    smulh x9, x7, x8
    mov x2, x9  // X2 = -1 = 0xFFFFFFFFFFFFFFFF

    brk #0