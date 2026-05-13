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
// Test: SBCS (64-bit) - Subtract with Carry and Set Flags
// SBCS Xd, Xn, Xm: Xd = Xn - Xm - NOT(C)
// With C=1: Xd = Xn - Xm - 0 = Xn - Xm
// With C=0: Xd = Xn - Xm - 1 = Xn - Xm - 1
// Tests NZCV flags including borrow propagation

.text
.global _start
_start:
    // Test 1: SBCS with C=1, 0 - 0 = 0
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov x10, #0x20000000  // C=1
    msr nzcv, x10
    mov x11, #0
    mov x12, #0
    sbcs x13, x11, x12    // 0 - 0 - 0 = 0
    mrs x0, nzcv

    // Test 2: SBCS with C=1, 5 - 3 = 2
    // N=0, Z=0, C=1, V=0 -> NZCV = 0x20000000
    mov x10, #0x20000000  // C=1
    msr nzcv, x10
    mov x11, #5
    mov x12, #3
    sbcs x13, x11, x12    // 5 - 3 = 2
    mrs x1, nzcv

    // Test 3: SBCS with C=1, 3 - 5 = -2 (borrow)
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #0x20000000  // C=1
    msr nzcv, x10
    mov x11, #3
    mov x12, #5
    sbcs x13, x11, x12    // 3 - 5 = -2 (unsigned borrow)
    mrs x2, nzcv

    // Test 4: SBCS with C=1, MIN_SIGNED - 1 = overflow
    // 0x8000000000000000 - 1 = 0x7FFFFFFFFFFFFFFF
    // N=0, Z=0, C=1, V=1 -> NZCV = 0x30000000
    mov x10, #0x20000000  // C=1
    msr nzcv, x10
    mov x11, #0x8000000000000000
    mov x12, #1
    sbcs x13, x11, x12
    mrs x3, nzcv

    // Test 5: SBCS with C=0, 0 - 0 - 1 = -1
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #0           // C=0
    msr nzcv, x10
    mov x11, #0
    mov x12, #0
    sbcs x13, x11, x12    // 0 - 0 - 1 = -1
    mrs x4, nzcv

    // Test 6: SBCS with C=0, same value - 1
    // 5 - 5 - 1 = -1
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #0           // C=0
    msr nzcv, x10
    mov x11, #5
    mov x12, #5
    sbcs x13, x11, x12
    mrs x5, nzcv

    // Test 7: SBCS with C=1, MAX_SIGNED - MIN_SIGNED
    // 0x7FFFFFFFFFFFFFFF - 0x8000000000000000 = -1
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    // Actually, let's try MAX_SIGNED - (-1):
    // 0x7FFFFFFFFFFFFFFF - 0xFFFFFFFFFFFFFFFF = 0 (overflow, C=0)
    // Wait, let me recalculate. MAX_SIGNED - (-1) with C=1:
    // = MAX_SIGNED - MAX_UNSIGNED = MAX_SIGNED + 1 = MIN_SIGNED (overflow)
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov x10, #0x20000000  // C=1
    msr nzcv, x10
    mov x11, #0x7FFFFFFFFFFFFFFF
    mov x12, #-1
    sbcs x13, x11, x12
    mrs x6, nzcv

    // Test 8: SBCS with C=1, overflow case
    // MAX_SIGNED - (-1) = overflow
    // Same as test 7
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov x10, #0x20000000  // C=1
    msr nzcv, x10
    mov x11, #0x7FFFFFFFFFFFFFFF
    mov x12, #0xFFFFFFFFFFFFFFFF
    sbcs x13, x11, x12
    mrs x7, nzcv

    brk #0