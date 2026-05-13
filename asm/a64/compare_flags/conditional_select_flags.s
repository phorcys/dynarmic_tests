/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000060000000",
    "X3": "0x00000000A0000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Conditional select operations with flags
    // ========================================

    // Test 0: CSEL (conditional select)
    mov x10, #100
    mov x11, #200
    cmp x10, x11             // 100 < 200, N=1
    csel x12, x10, x11, lt   // x12 = x10 if LT (true)
    subs x13, x12, #100
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: CSNEG (conditional select negate)
    mov x10, #50
    mov x11, #30
    cmp x10, x11             // 50 > 30, C=1
    csneg x12, x10, x11, le  // if LE false, x12 = -x11 = -30
    mov x13, #30
    neg x13, x13
    subs x14, x12, x13
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: CSINC (conditional select increment)
    mov x10, #10
    mov x11, #20
    cmp x10, x11             // 10 < 20
    csinc x12, x10, x11, ge  // if GE false, x12 = x11 + 1 = 21
    subs x13, x12, #21
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: CSINV (conditional select invert)
    mov x10, #0
    mov x11, #0
    cmp x10, x11             // equal, Z=1
    csinv x12, x10, x11, ne  // if NE false, x12 = ~x11 = -1
    subs x13, x12, #0
    mrs x3, nzcv             // Expected: N=1, C=1 (0xA0000000)

    brk #0