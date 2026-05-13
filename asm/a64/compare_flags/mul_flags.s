/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A",
    "X1": "0x0000000000000012",
    "X2": "0x000000000000001E",
    "X3": "0xFFFFFFFFFFFFFFE2"
  }
}
*/
// Test: Multiplication operations (MUL, MADD, MSUB, SMULL)
// These don't set flags in ARM64

.text
.global _start
_start:
    // Test 1: MUL (Multiply)
    mov w11, #6
    mov w12, #7
    mul w13, w11, w12        // 6 * 7 = 42 = 0x2A
    mov w0, w13              // x0 = 42

    // Test 2: MADD (Multiply-Add)
    // MADD Wd, Wn, Wm, Wa: Wd = Wa + (Wn * Wm)
    mov w11, #3
    mov w12, #4
    mov w14, #6
    madd w13, w11, w12, w14  // 6 + (3 * 4) = 18 = 0x12
    mov w1, w13              // x1 = 18

    // Test 3: MSUB (Multiply-Subtract)
    // MSUB Wd, Wn, Wm, Wa: Wd = Wa - (Wn * Wm)
    mov w11, #5
    mov w12, #6
    mov w14, #60
    msub w13, w11, w12, w14  // 60 - (5 * 6) = 30 = 0x1E
    mov w2, w13              // x2 = 30

    // Test 4: SMULL (Signed Multiply Long)
    // SMULL Xd, Wn, Wm: Xd = Wn * Wm (signed, 32-bit to 64-bit)
    mov w11, #-3
    mov w12, #10
    smull x13, w11, w12      // -3 * 10 = -30 = 0xFFFFFFFFFFFFFFE2
    mov x3, x13              // x3 = -30

    brk #0