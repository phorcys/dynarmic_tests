/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000000"
  }
}
*/
// Test: XOR operations (EOR, EON) with result checking
// EOR doesn't set flags in ARM64

.text
.global _start
_start:
    // Test 1: EOR (Exclusive OR)
    // EOR Wd, Wn, Wm: Wd = Wn XOR Wm
    mov w11, #0xFF
    mov w12, #0xFC
    eor w13, w11, w12        // 0xFF XOR 0xFC = 0x03
    mov w0, w13              // x0 = 3

    // Test 2: EOR with same value = 0
    mov w11, #0x1234
    eor w13, w11, w11        // x XOR x = 0
    mov w1, w13              // x1 = 0

    // Test 3: EON (Exclusive OR NOT)
    // EON Wd, Wn, Wm: Wd = Wn XOR (~Wm)
    mov w11, #0x0F
    mov w12, #0xF0
    eon w13, w11, w12        // 0x0F XOR (~0xF0) = 0x0F XOR 0xFFFFFF0F = 0xFFFFFF00
    // We'll just check bits [7:0] = 0x00
    and w2, w13, #0xFF       // x2 = 0

    brk #0