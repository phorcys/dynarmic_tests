/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x60000000",
    "X1": "0x80000000",
    "X2": "0x00000000",
    "X3": "0x90000000",
    "X4": "0x80000000",
    "X5": "0x80000000"
  }
}
*/
// Test: NGCS (64-bit) - Negate with Carry and Set Flags
// NGCS Xd, Xn = SBCS Xd, XZR, Xn
// result = 0 - Xn - NOT(C_in) = 0 - Xn - 1 + C_in
// With C=1: result = 0 - Xn
// With C=0: result = 0 - Xn - 1

.text
.global _start
_start:
    // Test 1: NGCS with C=1, 0 - 0 = 0
    // C_in=1, result = 0 - 0 = 0
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov x10, #0x20000000  // C=1
    msr nzcv, x10
    mov x11, #0
    ngcs x12, x11
    mrs x0, nzcv

    // Test 2: NGCS with C=1, 0 - 5 = -5
    // C_in=1, result = 0 - 5 = -5
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #0x20000000  // C=1
    msr nzcv, x10
    mov x11, #5
    ngcs x12, x11
    mrs x1, nzcv

    // Test 3: NGCS with C=1, 0 - (-5) = 5
    // C_in=1, result = 0 - (-5) = 5
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov x10, #0x20000000  // C=1
    msr nzcv, x10
    mov x11, #-5
    ngcs x12, x11
    mrs x2, nzcv

    // Test 4: NGCS with C=1, MIN_SIGNED = overflow
    // 0 - MIN_SIGNED = MIN_SIGNED (overflow)
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov x10, #0x20000000  // C=1
    msr nzcv, x10
    mov x11, #1
    lsl x11, x11, #63    // MIN_SIGNED64
    ngcs x12, x11
    mrs x3, nzcv

    // Test 5: NGCS with C=0, 0 - 0 - 1 = -1
    // C_in=0, result = 0 - 0 - 1 = -1
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #0           // C=0
    msr nzcv, x10
    mov x11, #0
    ngcs x12, x11
    mrs x4, nzcv

    // Test 6: NGCS with C=0, 0 - MAX_SIGNED - 1
    // C_in=0, result = 0 - 0x7FFFFFFFFFFFFFFF - 1 = 0x8000000000000000
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    // Wait, let me recalculate: 0 - MAX_SIGNED - 1
    // = -MAX_SIGNED - 1 = MIN_SIGNED (overflow? no, -MAX-1 = MIN exactly)
    // Actually 0 - 0x7FFFFFFFFFFFFFFF = 0x8000000000000001
    // Then - 1 = 0x8000000000000000 = MIN_SIGNED
    // For subtraction: C = (a >= result) = (0 >= MIN_SIGNED) = 0
    // V? Let's see: 0 - MAX - 1, both negative intermediate results
    // Let me use QEMU result
    mov x10, #0           // C=0
    msr nzcv, x10
    mov x11, #0x7FFFFFFFFFFFFFFF
    ngcs x12, x11
    mrs x5, nzcv

    brk #0