/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000060000000",
    "X3": "0x0000000060000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Count leading zeros/sign detailed
    // ========================================

    // Test 0: CLZ of all ones
    mov x10, #1
    neg x10, x10             // x10 = -1 (all ones)
    clz x11, x10             // count leading zeros = 0
    subs x12, x11, #0
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: CLZ of 0x8000...
    mov x10, #1
    lsl x10, x10, #63        // x10 = 0x8000000000000000
    clz x11, x10             // count leading zeros = 0
    subs x12, x11, #0
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: CLS of all ones
    mov x10, #1
    neg x10, x10             // x10 = -1 (all ones)
    cls x11, x10             // count leading sign bits = 63
    mov x12, #63
    subs x13, x11, x12
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: CLS of 0x7FFF000000000000
    mov x10, #0x7FFF
    lsl x10, x10, #48        // x10 = 0x7FFF000000000000
    cls x11, x10             // sign bit = 0, bit62 = 1, CLS = 0
    subs x12, x11, #0
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0
