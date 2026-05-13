/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000060000000",
    "X3": "0x0000000060000000",
    "X4": "0x0000000060000000",
    "X5": "0x0000000080000000",
    "X6": "0x0000000040000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Zero result flags tests
    // ========================================

    // Test 0: 0 + 0 = 0 -> Z=1
    mov x10, #0
    adds x12, x10, xzr
    mrs x0, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 1: 5 + (-5) = 0 -> Z=1
    mov x10, #5
    mov x11, #-5
    adds x12, x10, x11
    mrs x1, nzcv                 // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    // Test 2: Negative zero result? (-5) + 5 = 0 -> Z=1
    mov x10, #-5
    mov x11, #5
    adds x12, x10, x11
    mrs x2, nzcv                 // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    // Test 3: 0 - 0 = 0 -> Z=1
    mov x10, #0
    subs x12, x10, xzr
    mrs x3, nzcv                 // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    // Test 4: x - x = 0 -> Z=1
    mov x10, #42
    subs x12, x10, x10
    mrs x4, nzcv                 // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    // Test 5: AND with sign bit -> N=1
    mov x10, #1
    lsl x10, x10, #63            // x10 = 0x8000000000000000
    ands x12, x10, x10
    mrs x5, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 6: AND with zero -> Z=1
    mvn x10, xzr                 // x10 = all 1s
    ands x12, x10, xzr
    mrs x6, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    brk #0
