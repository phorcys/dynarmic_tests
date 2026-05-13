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
    // Conditional select negate tests
    // CSNEG: conditional select negate
    // ========================================

    // Test 0: CSNEG when condition true
    mov x10, #5
    mov x11, #10
    cmp x10, #5                  // EQ true
    csneg x12, x10, x11, eq      // if EQ: x12 = x10 = 5
    subs x13, x12, #5            // verify
    mrs x0, nzcv                 // Expected: Z=1, C=1

    // Test 1: CSNEG when condition false
    mov x10, #5
    mov x11, #10
    cmp x10, #6                  // EQ false
    csneg x12, x10, x11, eq      // if !EQ: x12 = -x11 = -10
    mov x13, #10
    neg x13, x13                 // x13 = -10
    subs x14, x12, x13           // verify
    mrs x1, nzcv                 // Expected: Z=1, C=1

    // Test 2: CSNEG with zero negate
    mov x10, #5
    mov x11, #0
    cmp x10, #6                  // EQ false
    csneg x12, x10, x11, eq      // if !EQ: x12 = -0 = 0
    subs x13, x12, #0            // verify
    mrs x2, nzcv                 // Expected: Z=1, C=1

    // Test 3: CSNEG with negative input
    mov x10, #5
    mov x11, #10
    neg x11, x11                 // x11 = -10
    cmp x10, #6                  // EQ false
    csneg x12, x10, x11, eq      // if !EQ: x12 = -(-10) = 10
    subs x13, x12, #10           // verify
    mrs x3, nzcv                 // Expected: Z=1, C=1

    brk #0
