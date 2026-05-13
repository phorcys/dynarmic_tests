/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x40000000",
    "X1": "0x00000000",
    "X2": "0x60000000",
    "X3": "0x90000000",
    "X4": "0xA0000000",
    "X5": "0x00000000",
    "X6": "0xA0000000",
    "X7": "0x30000000"
  }
}
*/
// Test: ADCSW (32-bit) - Add with Carry and Set Flags
// ADCS Wd, Wn, Wm: Wd = Wn + Wm + C
// Tests NZCV flags including carry propagation

.text
.global _start
_start:
    // Test 1: ADCSW with C=0, 0 + 0 + 0 = 0
    // N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    mov w10, #0           // C=0
    msr nzcv, x10
    mov w11, #0
    mov w12, #0
    adcs w13, w11, w12
    mrs x0, nzcv

    // Test 2: ADCSW with C=0, 5 + 3 = 8
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov w10, #0           // C=0
    msr nzcv, x10
    mov w11, #5
    mov w12, #3
    adcs w13, w11, w12
    mrs x1, nzcv

    // Test 3: ADCSW with C=1, -1 + 0 + 1 = 0 (32-bit wrap)
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov w10, #0x20000000  // C=1
    msr nzcv, x10
    mov w11, #-1
    mov w12, #0
    adcs w13, w11, w12
    mrs x2, nzcv

    // Test 4: ADCSW with C=1, MAX_SIGNED32 + 0 + 1 = overflow
    // 0x7FFFFFFF + 1 = 0x80000000 (overflow)
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov w10, #0x20000000  // C=1
    msr nzcv, x10
    mov w11, #0x7FFFFFFF
    mov w12, #0
    adcs w13, w11, w12
    mrs x3, nzcv

    // Test 5: ADCSW with C=1, -1 + -1 + 1 = -1 (with carry)
    // N=1, Z=0, C=1, V=0 -> NZCV = 0xA0000000
    mov w10, #0x20000000  // C=1
    msr nzcv, x10
    mov w11, #-1
    mov w12, #-1
    adcs w13, w11, w12
    mrs x4, nzcv

    // Test 6: ADCSW with C=0, normal positive
    // 100 + 200 = 300
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov w10, #0           // C=0
    msr nzcv, x10
    mov w11, #100
    mov w12, #200
    adcs w13, w11, w12
    mrs x5, nzcv

    // Test 7: ADCSW with C=1, MIN_SIGNED32 + (-1) + 1 = MIN_SIGNED32
    // N=1, Z=0, C=1, V=0 -> NZCV = 0xA0000000
    mov w10, #0x20000000  // C=1
    msr nzcv, x10
    mov w11, #0x80000000
    mov w12, #-1
    adcs w13, w11, w12
    mrs x6, nzcv

    // Test 8: ADCSW with C=1, both MIN_SIGNED + overflow
    // 0x80000000 + 0x80000000 + 1 = 0x00000001 (with carry, overflow)
    // N=0, Z=0, C=1, V=1 -> NZCV = 0x30000000
    mov w10, #0x20000000  // C=1
    msr nzcv, x10
    mov w11, #0x80000000
    mov w12, #0x80000000
    adcs w13, w11, w12
    mrs x7, nzcv

    brk #0