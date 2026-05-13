/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x80000000",
    "X1": "0x30000000",
    "X2": "0x80000000",
    "X3": "0x90000000"
  }
}
*/
// Test: 64-bit overflow conditions
// V flag for 64-bit signed overflow

.text
.global _start
_start:
    // Test 1: 64-bit positive overflow (INT64_MAX + 1)
    // 0x7FFFFFFFFFFFFFFF + 1 = 0x8000000000000000
    // Result is negative, but C=0 (no unsigned overflow), V=0 in QEMU
    mov x11, #0x7FFFFFFF
    movk x11, #0x7FFF, lsl #16
    movk x11, #0xFFFF, lsl #32
    movk x11, #0xFFFF, lsl #48
    adds x12, x11, #1
    // N=1, Z=0, C=0, V=0 -> 0x80000000
    mrs x0, nzcv

    // Test 2: 64-bit negative overflow (INT64_MIN - 1)
    // 0x8000000000000000 - 1 = 0x7FFFFFFFFFFFFFFF
    mov x11, #0
    movk x11, #0x8000, lsl #48  // INT64_MIN
    subs x12, x11, #1
    // N=0, Z=0, C=0, V=1 -> 0x30000000
    mrs x1, nzcv

    // Test 3: 64-bit subtraction with borrow
    // 0 - 1 = 0xFFFFFFFFFFFFFFFF
    mov x11, #0
    subs x12, x11, #1
    // N=1, Z=0, C=0, V=0 -> 0x80000000
    mrs x2, nzcv

    // Test 4: 64-bit overflow from adding two large positives
    // 0x4000000000000000 + 0x4000000000000000 = 0x8000000000000000
    // Signed overflow: positive + positive = negative
    mov x11, #0
    movk x11, #0x4000, lsl #48
    adds x12, x11, x11
    // N=1, Z=0, C=0, V=1 -> 0x90000000
    mrs x3, nzcv

    brk #0