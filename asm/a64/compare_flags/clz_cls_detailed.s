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
    // Population count (CNT) and bit counting
    // ========================================

    // Test 0: CLZ (count leading zeros)
    mov x10, #0x80
    lsl x10, x10, #56       // x10 = 0x8000000000000000
    clz x11, x10            // count leading zeros = 0
    subs x12, x11, #0
    mrs x0, nzcv            // Expected: Z=1, C=1

    // Test 1: CLZ with all zeros
    mov x10, #0
    clz x11, x10            // count leading zeros = 64
    subs x12, x11, #64
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: CLS (count leading sign bits)
    mov x10, #0x40
    lsl x10, x10, #56       // x10 = 0x4000000000000000 (positive, bit 62=1)
    cls x11, x10            // count leading sign bits (sign is 0, count 0s after sign)
    // bit 63=0, bit 62=1, so cls = 1-1 = 0? Let me check...
    // Actually CLS counts consecutive bits equal to sign bit
    // For 0x4000000000000000: sign bit = 0, next bit = 1, so CLS = 0
    subs x12, x11, #0
    mrs x2, nzcv            // Expected: Z=1, C=1

    // Test 3: CLS with negative
    mov x10, #0xC0
    lsl x10, x10, #56       // x10 = 0xC000000000000000 (negative)
    cls x11, x10            // count leading sign bits = 1
    subs x12, x11, #1
    mrs x3, nzcv            // Expected: Z=1, C=1

    brk #0
