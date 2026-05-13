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
    // Condition codes comprehensive tests
    // ========================================

    // Test 0: HI (higher, C=1 && Z=0)
    mov x10, #20
    mov x11, #10
    cmp x10, x11             // 20 > 10, C=1, Z=0
    cset x12, hi             // x12 = 1 if HI
    subs x13, x12, #1
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: LS (lower or same, C=0 || Z=1)
    mov x10, #10
    mov x11, #20
    cmp x10, x11             // 10 < 20, C=0, Z=0
    cset x12, ls             // x12 = 1 if LS (C=0 is true)
    subs x13, x12, #1
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: HS (higher or same, C=1)
    mov x10, #20
    mov x11, #10
    cmp x10, x11             // 20 >= 10, C=1
    cset x12, hs             // x12 = 1 if HS
    subs x13, x12, #1
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: LO (lower, C=0)
    mov x10, #10
    mov x11, #20
    cmp x10, x11             // 10 < 20, C=0
    cset x12, lo             // x12 = 1 if LO
    subs x13, x12, #1
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0
