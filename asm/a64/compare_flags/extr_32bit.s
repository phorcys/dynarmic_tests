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
    // EXTR with 32-bit registers (W form)
    // ========================================

    // Test 0: EXTR with W registers, lsb=0
    mov w10, #0xAB
    mov w11, #0xCD
    extr w12, w10, w11, #0   // w12 = w11 = 0xCD
    subs w13, w12, #0xCD
    mrs x0, nzcv             // Expected: Z=1, C=1

    // Test 1: EXTR with W registers, lsb=16
    mov w10, #0xAB
    mov w11, #0xCD
    lsl w11, w11, #16        // w11 = 0xCD0000
    extr w12, w10, w11, #16  // (w10 << 16) | (w11 >> 16)
    // w10 << 16 = 0xAB0000
    // w11 >> 16 = 0xCD
    // Result = 0xAB00CD
    movz w13, #0x00CD
    movk w13, #0x00AB, lsl #16
    subs w14, w12, w13
    mrs x1, nzcv             // Expected: Z=1, C=1

    // Test 2: EXTR with W registers, lsb=24
    mov w10, #0xAB
    mov w11, #0xCD
    lsl w11, w11, #24        // w11 = 0xCD000000
    extr w12, w10, w11, #24  // (w10 << 8) | (w11 >> 24)
    // w10 << 8 = 0xAB00
    // w11 >> 24 = 0xCD
    // Result = 0xABCD
    movz w13, #0xABCD
    subs w14, w12, w13
    mrs x2, nzcv             // Expected: Z=1, C=1

    // Test 3: EXTR with W registers, max lsb=31
    mov w10, #0xAB
    mov w11, #0xCD
    extr w12, w10, w11, #31  // (w10 << 1) | (w11 >> 31)
    // w10 << 1 = 0x156
    // w11 >> 31 = 0
    // Result = 0x156
    mov w13, #0x156
    subs w14, w12, w13
    mrs x3, nzcv             // Expected: Z=1, C=1

    brk #0