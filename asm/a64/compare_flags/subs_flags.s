/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x60000000",
    "X1": "0x20000000",
    "X2": "0x80000000",
    "X3": "0x30000000",
    "X4": "0x80000000",
    "X5": "0x90000000",
    "X6": "0x60000000",
    "X7": "0xA0000000"
  }
}
*/
// Test: SUBS (64-bit) - Subtract and Set Flags
// Tests all NZCV flag combinations
// For SUBS: C=1 means no borrow (a >= b unsigned), C=0 means borrow

.text
.global _start
_start:
    // Test 1: 0 - 0 = 0
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov x10, #0
    mov x11, #0
    subs x12, x10, x11
    mrs x0, nzcv

    // Test 2: 5 - 3 = 2 (no borrow)
    // N=0, Z=0, C=1, V=0 -> NZCV = 0x20000000
    mov x10, #5
    mov x11, #3
    subs x12, x10, x11
    mrs x1, nzcv

    // Test 3: 3 - 5 = -2 (borrow)
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #3
    mov x11, #5
    subs x12, x10, x11
    mrs x2, nzcv

    // Test 4: MIN_SIGNED - 1 = MAX_SIGNED (overflow)
    // N=0, Z=0, C=1, V=1 -> NZCV = 0x30000000
    mov x10, #0x8000000000000000
    mov x11, #1
    subs x12, x10, x11
    mrs x3, nzcv

    // Test 5: 0 - 1 = -1 (borrow)
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #0
    mov x11, #1
    subs x12, x10, x11
    mrs x4, nzcv

    // Test 6: MAX_SIGNED - (-1) = overflow (MIN_SIGNED)
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov x10, #0x7FFFFFFFFFFFFFFF
    mov x11, #-1
    subs x12, x10, x11
    mrs x5, nzcv

    // Test 7: Same values -> 0
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov x10, #42
    mov x11, #42
    subs x12, x10, x11
    mrs x6, nzcv

    // Test 8: MAX_UNSIGNED - 0 = MAX_UNSIGNED (negative bit set, no overflow)
    // N=1, Z=0, C=1, V=0 -> NZCV = 0xA0000000
    mov x10, #-1
    mov x11, #0
    subs x12, x10, x11
    mrs x7, nzcv

    brk #0