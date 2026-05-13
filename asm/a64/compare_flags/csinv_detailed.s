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
    // Conditional select inverse tests
    // CSINV: conditional select invert
    // ========================================

    // Test 0: CSINV when condition true
    mov x10, #5
    mov x11, #0
    cmp x10, #5                  // EQ true
    csinv x12, x10, x11, eq      // if EQ: x12 = x10 = 5
    subs x13, x12, #5            // verify
    mrs x0, nzcv                 // Expected: Z=1, C=1

    // Test 1: CSINV when condition false
    mov x10, #5
    mov x11, #0
    cmp x10, #6                  // EQ false
    csinv x12, x10, x11, eq      // if !EQ: x12 = ~x11 = ~0 = -1
    mvn x13, xzr                 // x13 = -1
    subs x14, x12, x13           // verify
    mrs x1, nzcv                 // Expected: Z=1, C=1

    // Test 2: CSINV with both values, condition true
    mov x10, #0x55
    mov x11, #0xAA
    cmp xzr, xzr                 // EQ true
    csinv x12, x10, x11, eq      // x12 = x10 = 0x55
    subs x13, x12, #0x55         // verify
    mrs x2, nzcv                 // Expected: Z=1, C=1

    // Test 3: CSINV with both values, condition false
    mov x10, #0x55
    mov x11, #0xAA
    mov x14, #1
    cmp xzr, x14                 // Always NE (0 != 1)
    csinv x12, x10, x11, ne      // if NE: x12 = x10 = 0x55
    subs x13, x12, #0x55         // verify
    mrs x3, nzcv                 // Expected: Z=1, C=1

    brk #0