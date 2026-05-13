/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000A0000000",
    "X1": "0x0000000020000000",
    "X2": "0x0000000020000000",
    "X3": "0x0000000020000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // CRC32C (CRC32 Castagnoli) tests
    // Uses CRC-32C polynomial
    // ========================================

    // Test 0: CRC32CB (byte)
    mov w10, #0             // initial CRC = 0
    mov w11, #0x41          // 'A' = 0x41
    crc32cb w12, w10, w11   // compute CRC32C
    subs w13, w12, #0       // check non-zero
    mrs x0, nzcv            // Expected: N=1

    // Test 1: CRC32CH (halfword)
    mov w10, #0             // initial CRC = 0
    movz w11, #0x4141       // "AA"
    crc32ch w12, w10, w11
    subs w13, w12, #0       // check non-zero
    mrs x1, nzcv            // Expected: C=1

    // Test 2: CRC32CW (word)
    mov w10, #0             // initial CRC = 0
    movz w11, #0x4141
    movk w11, #0x4141, lsl #16  // w11 = 0x41414141
    crc32cw w12, w10, w11
    subs w13, w12, #0       // check non-zero
    mrs x2, nzcv            // Expected: C=1

    // Test 3: CRC32CX (doubleword)
    mov x10, #0             // initial CRC = 0
    mov x11, #0x41
    crc32cx w12, w10, x11
    subs w13, w12, #0       // check non-zero
    mrs x3, nzcv            // Expected: C=1

    brk #0