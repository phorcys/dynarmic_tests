/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x60000000",
    "X1": "0x20000000",
    "X2": "0x80000000",
    "X3": "0x90000000",
    "X4": "0x70000000",
    "X5": "0x80000000"
  }
}
*/
// Test: CMP/CMN - Compare and Compare Negative
// CMP Wn, Wm: sets flags as if Wn - Wm
// CMN Wn, Wm: sets flags as if Wn + Wm

.text
.global _start
_start:
    // Test 1: CMP equal values
    // 5 - 5 = 0, N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov w11, #5
    mov w12, #5
    cmp w11, w12
    mrs x0, nzcv

    // Test 2: CMP a > b (no borrow)
    // 10 - 5 = 5, N=0, Z=0, C=1, V=0 -> NZCV = 0x20000000
    mov w11, #10
    mov w12, #5
    cmp w11, w12
    mrs x1, nzcv

    // Test 3: CMP a < b (borrow)
    // 5 - 10 = -5, N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov w11, #5
    mov w12, #10
    cmp w11, w12
    mrs x2, nzcv

    // Test 4: CMN positive + positive = negative (overflow)
    // MAX + MAX = 0xFFFFFFFE (signed overflow)
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov w11, #0x7FFFFFFF
    mov w12, #0x7FFFFFFF
    cmn w11, w12
    mrs x3, nzcv

    // Test 5: CMN negative + negative = zero with carry and overflow
    // MIN + MIN = 0 (with carry out, signed overflow)
    // N=0, Z=1, C=1, V=1 -> NZCV = 0x70000000
    mov w11, #0x80000000
    mov w12, #0x80000000
    cmn w11, w12
    mrs x4, nzcv

    // Test 6: CMP large unsigned values (borrow)
    // 0 - 1 = -1 (wrap), N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov w11, #0
    mov w12, #1
    cmp w11, w12
    mrs x5, nzcv

    brk #0