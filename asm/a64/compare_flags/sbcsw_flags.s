/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x60000000",
    "X1": "0x20000000",
    "X2": "0x80000000",
    "X3": "0x30000000",
    "X4": "0x80000000",
    "X5": "0x80000000",
    "X6": "0x90000000",
    "X7": "0x90000000"
  }
}
*/
// Test: SBCSW (32-bit) - Subtract with Carry and Set Flags
// SBCS Wd, Wn, Wm: Wd = Wn - Wm - NOT(C)
// With C=1: Wd = Wn - Wm
// With C=0: Wd = Wn - Wm - 1

.text
.global _start
_start:
    // Test 1: SBCSW with C=1, 0 - 0 = 0
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov w10, #0x20000000  // C=1
    msr nzcv, x10
    mov w11, #0
    mov w12, #0
    sbcs w13, w11, w12
    mrs x0, nzcv

    // Test 2: SBCSW with C=1, 5 - 3 = 2
    // N=0, Z=0, C=1, V=0 -> NZCV = 0x20000000
    mov w10, #0x20000000  // C=1
    msr nzcv, x10
    mov w11, #5
    mov w12, #3
    sbcs w13, w11, w12
    mrs x1, nzcv

    // Test 3: SBCSW with C=1, 3 - 5 = -2 (borrow)
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov w10, #0x20000000  // C=1
    msr nzcv, x10
    mov w11, #3
    mov w12, #5
    sbcs w13, w11, w12
    mrs x2, nzcv

    // Test 4: SBCSW with C=1, MIN_SIGNED32 - 1 = overflow
    // 0x80000000 - 1 = 0x7FFFFFFF (overflow, positive)
    // N=0, Z=0, C=1, V=1 -> NZCV = 0x30000000
    mov w10, #0x20000000  // C=1
    msr nzcv, x10
    mov w11, #0x80000000
    mov w12, #1
    sbcs w13, w11, w12
    mrs x3, nzcv

    // Test 5: SBCSW with C=0, 0 - 0 - 1 = -1
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov w10, #0           // C=0
    msr nzcv, x10
    mov w11, #0
    mov w12, #0
    sbcs w13, w11, w12
    mrs x4, nzcv

    // Test 6: SBCSW with C=0, same value - 1
    // 5 - 5 - 1 = -1
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov w10, #0           // C=0
    msr nzcv, x10
    mov w11, #5
    mov w12, #5
    sbcs w13, w11, w12
    mrs x5, nzcv

    // Test 7: SBCSW with C=1, MAX_SIGNED32 - MIN_SIGNED32
    // 0x7FFFFFFF - 0x80000000 = 0xFFFFFFFF (-1)
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov w10, #0x20000000  // C=1
    msr nzcv, x10
    mov w11, #0x7FFFFFFF
    mov w12, #0x80000000
    sbcs w13, w11, w12
    mrs x6, nzcv

    // Test 8: SBCSW with C=1, MAX_SIGNED32 - (-1) = overflow
    // 0x7FFFFFFF - 0xFFFFFFFF = 0x80000000
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov w10, #0x20000000  // C=1
    msr nzcv, x10
    mov w11, #0x7FFFFFFF
    mov w12, #-1
    sbcs w13, w11, w12
    mrs x7, nzcv

    brk #0
