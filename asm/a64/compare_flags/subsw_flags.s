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
    "X7": "0x90000000"
  }
}
*/
// Test: SUBSW (32-bit) - Subtract and Set Flags
// N = bit 31 of result
// Z = (result == 0) ? 1 : 0
// C = !borrow (a >= b unsigned)
// V = signed overflow

.text
.global _start
_start:
    // Test 1: SUBSW 0 - 0 = 0
    // N=0, Z=1, C=1 (no borrow), V=0 -> NZCV = 0x60000000
    mov w10, #0
    mov w11, #0
    subs w12, w10, w11
    mrs x0, nzcv

    // Test 2: SUBSW 5 - 3 = 2
    // N=0, Z=0, C=1, V=0 -> NZCV = 0x20000000
    mov w10, #5
    mov w11, #3
    subs w12, w10, w11
    mrs x1, nzcv

    // Test 3: SUBSW 3 - 5 = -2 (borrow)
    // N=1, Z=0, C=0 (borrow), V=0 -> NZCV = 0x80000000
    mov w10, #3
    mov w11, #5
    subs w12, w10, w11
    mrs x2, nzcv

    // Test 4: SUBSW MIN_SIGNED32 - 1 = overflow
    // 0x80000000 - 1 = 0x7FFFFFFF (overflow, positive)
    // N=0, Z=0, C=1, V=1 -> NZCV = 0x30000000
    mov w10, #0x80000000
    mov w11, #1
    subs w12, w10, w11
    mrs x3, nzcv

    // Test 5: SUBSW 0 - 1 = -1 (borrow)
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov w10, #0
    mov w11, #1
    subs w12, w10, w11
    mrs x4, nzcv

    // Test 6: SUBSW MAX_SIGNED32 - MIN_SIGNED32 = overflow
    // 0x7FFFFFFF - 0x80000000 = 0xFFFFFFFF (-1)
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov w10, #0x7FFFFFFF
    mov w11, #0x80000000
    subs w12, w10, w11
    mrs x5, nzcv

    // Test 7: SUBSW same value = 0
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov w10, #123
    mov w11, #123
    subs w12, w10, w11
    mrs x6, nzcv

    // Test 8: SUBSW MAX_SIGNED32 - (-1) = overflow
    // 0x7FFFFFFF - 0xFFFFFFFF = 0x80000000
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov w10, #0x7FFFFFFF
    mov w11, #-1
    subs w12, w10, w11
    mrs x7, nzcv

    brk #0