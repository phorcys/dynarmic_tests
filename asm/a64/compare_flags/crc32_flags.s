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
    // CRC32 with flags
    // ========================================

    // Test 0: CRC32B
    mov w10, #0              // initial CRC
    mov w11, #0x41           // 'A'
    crc32b w12, w10, w11     // compute CRC
    subs w13, w12, w12
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: CRC32H
    mov w10, #0              // initial CRC
    mov w11, #0x4142         // 'AB'
    crc32h w12, w10, w11     // compute CRC
    subs w13, w12, w12
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: CRC32W
    mov w10, #0              // initial CRC
    mov w11, #0x1234         // test data
    crc32w w12, w10, w11     // compute CRC
    subs w13, w12, w12
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: CRC32X
    mov w10, #0              // initial CRC
    mov x11, #0x1234
    movk x11, #0x5678, lsl #16
    crc32x w12, w10, x11     // compute CRC
    subs w13, w12, w12
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0
