/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x00000000A0000000",
    "X2": "0x00000000A0000000",
    "X3": "0x0000000060000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Bit manipulation with flags
    // ========================================

    // Test 0: BIC (bit clear) with immediate
    mov x10, #0xFF
    mov x11, #0x0F
    bic x12, x10, x11       // x12 = 0xFF & ~0x0F = 0xF0
    subs x13, x12, #0xF0
    mrs x0, nzcv            // Expected: Z=1, C=1

    // Test 1: ORN (or not) - produces negative result
    mov x10, #0xF0
    mov x11, #0x0F
    orn x12, x10, x11       // x12 = 0xF0 | ~0x0F = 0xF0 | 0xFFFFFFFFFFFFFFF0 = 0xFFFFFFFFFFFFFFF0
    subs x13, x12, #0       // N=1 because result is negative
    mrs x1, nzcv            // Expected: N=1

    // Test 2: EON (exclusive or not) - produces negative result
    mov x10, #0xFF
    mov x11, #0x0F
    eon x12, x10, x11       // x12 = 0xFF ^ ~0x0F = 0xFF ^ 0xFFFFFFFFFFFFFFF0 = 0xFFFFFFFFFFFFFF0F
    subs x13, x12, #0       // N=1 because result is negative
    mrs x2, nzcv            // Expected: N=1

    // Test 3: BIC with shifted register
    mov x10, #0xFF00
    mov x11, #1
    bic x12, x10, x11, lsl #4   // x12 = 0xFF00 & ~0x10 = 0xFF00
    mov x13, #0xFF
    lsl x13, x13, #8        // x13 = 0xFF00
    subs x14, x12, x13
    mrs x3, nzcv            // Expected: Z=1, C=1

    brk #0
