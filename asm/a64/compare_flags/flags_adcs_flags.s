/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x40000000",
    "X1": "0x00000000",
    "X2": "0x60000000",
    "X3": "0x90000000",
    "X4": "0x60000000",
    "X5": "0x00000000",
    "X6": "0x60000000",
    "X7": "0x90000000"
  }
}
*/
// Test: ADCS (64-bit) - Add with Carry and Set Flags
// ADCS Xd, Xn, Xm: Xd = Xn + Xm + C (C from previous operation)
// Tests NZCV flags including carry propagation

.text
.global _start
_start:
    // First, set up initial flags state using MSR
    // MSR NZCV, Xn sets NZCV from Xn

    // Test 1: ADCS with C=0, 0 + 0 + 0 = 0
    // N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    mov x10, #0
    msr nzcv, x10         // Clear all flags (C=0)
    mov x11, #0
    mov x12, #0
    adcs x13, x11, x12    // 0 + 0 + 0 = 0
    mrs x0, nzcv

    // Test 2: ADCS with C=1, 0 + 0 + 1 = 1
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov x10, #0x20000000  // C=1 only
    msr nzcv, x10
    mov x11, #0
    mov x12, #0
    adcs x13, x11, x12    // 0 + 0 + 1 = 1
    mrs x1, nzcv

    // Test 3: ADCS with C=1, MAX + 0 + 1 = 0 with carry
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov x10, #0x20000000  // C=1
    msr nzcv, x10
    mov x11, #-1          // MAX_UNSIGNED
    mov x12, #0
    adcs x13, x11, x12    // MAX + 0 + 1 = 0 with carry
    mrs x2, nzcv

    // Test 4: ADCS with C=0, MAX_SIGNED + 1 + 0 = overflow
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov x10, #0           // C=0
    msr nzcv, x10
    mov x11, #0x7FFFFFFFFFFFFFFF
    mov x12, #1
    adcs x13, x11, x12
    mrs x3, nzcv

    // Test 5: ADCS with C=1, MAX_UNSIGNED + 0 + 1 = 0
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov x10, #0x20000000  // C=1
    msr nzcv, x10
    mov x11, #-1          // MAX_UNSIGNED
    mov x12, #0
    adcs x13, x11, x12
    mrs x4, nzcv

    // Test 6: ADCS with C=0, positive result
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov x10, #0
    msr nzcv, x10
    mov x11, #5
    mov x12, #3
    adcs x13, x11, x12    // 5 + 3 + 0 = 8
    mrs x5, nzcv

    // Test 7: ADCS with C=1, overflow
    // MIN_SIGNED + MAX_SIGNED + 1 = 0
    // 0x8000000000000000 + 0x7FFFFFFFFFFFFFFF + 1 = 0
    // N=0, Z=1, C=1, V=1 -> NZCV = 0x70000000
    // Wait, let me recalculate:
    // Actually QEMU returns 0x60000000, let me check
    mov x10, #0x20000000  // C=1
    msr nzcv, x10
    mov x11, #0x8000000000000000
    mov x12, #0x7FFFFFFFFFFFFFFF
    adcs x13, x11, x12
    mrs x6, nzcv

    // Test 8: ADCS with C=1, creating overflow
    // 0x7FFFFFFFFFFFFFFE + 1 + 1 = 0x8000000000000000
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov x10, #0x20000000  // C=1
    msr nzcv, x10
    mov x11, #0x7FFFFFFFFFFFFFFE
    mov x12, #1
    adcs x13, x11, x12
    mrs x7, nzcv

    brk #0