/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000070000000",
    "X3": "0x0000000090000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // ADCS (Add with Carry and Set flags)
    // ========================================

    // Test 0: ADCS with C=0
    mov x10, #5
    mov x11, #3
    mov x12, #0
    subs x13, x12, #1       // C=0 (borrow)
    adcs x14, x10, x11      // 5 + 3 + 0 = 8
    subs x15, x14, #8
    mrs x0, nzcv            // Expected: Z=1, C=1

    // Test 1: ADCS with C=1
    mov x10, #5
    mov x11, #3
    cmp x10, x10            // Z=1, C=1
    adcs x14, x10, x11      // 5 + 3 + 1 = 9
    subs x15, x14, #9
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: ADCS overflow
    mov x10, #1
    lsl x10, x10, #63       // x10 = INT64_MIN
    mov x11, #1
    lsl x11, x11, #63       // x11 = INT64_MIN
    mov x12, #0
    subs x13, x12, #1       // C=0
    adcs x14, x10, x11      // INT64_MIN + INT64_MIN + 0 = 0 with overflow
    mrs x2, nzcv            // Expected: N=1, V=1, C=1

    // Test 3: ADCS 32-bit
    movz w10, #0xFFFF
    movk w10, #0x7FFF, lsl #16  // w10 = INT32_MAX
    mov w11, #1
    mov x12, #0
    subs x13, x12, #1       // C=0
    adcs w14, w10, w11      // INT32_MAX + 1 = overflow
    mrs x3, nzcv            // Expected: N=1, V=1, C=1

    brk #0
