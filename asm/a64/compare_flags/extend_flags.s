/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000060000000",
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
    // EXT (signed/unsigned extend) tests
    // SXTB, SXTH, SXTW, UXTB, UXTH
    // ========================================

    // Test 0: SXTB (sign-extend byte)
    mov w10, #0x80           // 0x80 = -128 in signed byte
    sxtb x11, w10            // sign-extend byte
    // x11 = 0xFFFFFFFFFFFFFF80 = -128
    mov x12, #-128
    subs x13, x11, x12
    mrs x0, nzcv             // Expected: Z=1, C=1

    // Test 1: SXTH (sign-extend halfword)
    mov w10, #0x8000         // 0x8000 = -32768 in signed halfword
    sxth x11, w10            // sign-extend halfword
    // x11 = 0xFFFFFFFFFFFF8000 = -32768
    mov x12, #-32768
    subs x13, x11, x12
    mrs x1, nzcv             // Expected: Z=1, C=1

    // Test 2: UXTB (zero-extend byte)
    mov w10, #0xFF
    uxtb w11, w10            // zero-extend byte
    // w11 = 0xFF
    subs w12, w11, #0xFF
    mrs x2, nzcv             // Expected: Z=1, C=1

    // Test 3: UXTH (zero-extend halfword)
    // 用 lsl 来构造 0xFFFF
    mov w10, #0xFF
    lsl w10, w10, #8         // w10 = 0xFF00
    orr w10, w10, #0xFF      // w10 = 0xFFFF
    uxth w11, w10            // zero-extend halfword
    // w11 = 0xFFFF
    mov w12, #0xFF
    lsl w12, w12, #8
    orr w12, w12, #0xFF      // w12 = 0xFFFF
    subs w13, w11, w12
    mrs x3, nzcv             // Expected: Z=1, C=1

    brk #0