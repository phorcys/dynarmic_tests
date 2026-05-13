/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x40000000",
    "X1": "0x60000000",
    "X2": "0x80000000",
    "X3": "0x90000000",
    "X4": "0x60000000",
    "X5": "0x00000000",
    "X6": "0x30000000",
    "X7": "0x90000000"
  }
}
*/
// Test: ADDS (64-bit) - Add and Set Flags
// Tests all NZCV flag combinations

.text
.global _start
_start:
    // Test 1: 0 + 0 = 0
    // N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    mov x10, #0
    mov x11, #0
    adds x12, x10, x11
    mrs x0, nzcv

    // Test 2: -1 + 1 = 0 (with carry)
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov x10, #-1
    mov x11, #1
    adds x12, x10, x11
    mrs x1, nzcv

    // Test 3: -2 + 1 = -1 (negative)
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #-2
    mov x11, #1
    adds x12, x10, x11
    mrs x2, nzcv

    // Test 4: MAX_SIGNED + 1 = overflow (MIN_SIGNED)
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov x10, #0x7FFFFFFFFFFFFFFF
    mov x11, #1
    adds x12, x10, x11
    mrs x3, nzcv

    // Test 5: MAX_UNSIGNED + 1 = 0 (with carry)
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov x10, #-1
    mov x11, #1
    adds x12, x10, x11
    mrs x4, nzcv

    // Test 6: 5 + 3 = 8 (positive, no flags)
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov x10, #5
    mov x11, #3
    adds x12, x10, x11
    mrs x5, nzcv

    // Test 7: MIN_SIGNED + (-1) = MAX_SIGNED (overflow)
    // N=0, Z=0, C=1, V=1 -> NZCV = 0x30000000
    mov x10, #0x8000000000000000
    mov x11, #-1
    adds x12, x10, x11
    mrs x6, nzcv

    // Test 8: Large positive + large positive = overflow
    // 0x4000000000000000 + 0x5000000000000000 = 0x9000000000000000
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov x10, #0x4000000000000000
    mov x11, #0x5000000000000000
    adds x12, x10, x11
    mrs x7, nzcv

    brk #0
