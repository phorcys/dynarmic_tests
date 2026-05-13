/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040000000",
    "X1": "0x0000000090000000",
    "X2": "0x0000000030000000",
    "X3": "0x0000000000000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // 64-bit arithmetic edge cases with flags
    // ========================================

    // Test 0: ADDS zero + zero
    mov x10, #0
    mov x11, #0
    adds x12, x10, x11       // 0 + 0 = 0, Z=1, C=0
    mrs x0, nzcv             // Expected: Z=1 (0x40000000)

    // Test 1: ADDS max positive + 1 (overflow)
    mov x10, #0x7FFFFFFFFFFFFFFF
    mov x11, #1
    adds x12, x10, x11       // INT64_MAX + 1 = 0x8000..., N=1, V=1
    mrs x1, nzcv             // Expected: N=1, V=1 (0x90000000)

    // Test 2: SUBS min - 1 (underflow)
    mov x10, #0x8000000000000000
    mov x11, #1
    subs x12, x10, x11       // INT64_MIN - 1 = 0x7FFF..., C=0 (borrow), N=0
    mrs x2, nzcv             // Expected: C=0 (borrow), N=0 (0x30000000)

    // Test 3: CMN (compare negative)
    mov x10, #100
    cmn x10, #100            // x10 + 100 = 200
    mrs x3, nzcv             // Expected: all clear (0x00000000)

    brk #0