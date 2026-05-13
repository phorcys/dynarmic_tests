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
    // CLZ/CLS (Count leading zeros/sign bits) flags tests
    // These do NOT set flags, but we verify results with SUBS
    // ========================================

    // Test 0: CLZ basic
    mov x10, #0x80
    lsl x10, x10, #56       // x10 = 0x8000000000000000 (bit 63 set)
    clz x12, x10            // count leading zeros = 0
    subs x13, x12, #0
    mrs x0, nzcv            // Expected: Z=1, C=1

    // Test 1: CLZ with zero
    mov x10, #0
    clz x12, x10            // count leading zeros = 64
    subs x13, x12, #64
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: CLS (count leading sign bits)
    mov x10, #0xC0
    lsl x10, x10, #56       // x10 = 0xC000000000000000 (negative)
    cls x12, x10            // count leading sign bits = 1 (bit 62 differs)
    subs x13, x12, #1
    mrs x2, nzcv            // Expected: Z=1, C=1

    // Test 3: CLS positive
    mov x10, #0x40
    lsl x10, x10, #56       // x10 = 0x4000000000000000 (positive)
    cls x12, x10            // count leading sign bits = 0 (bit 63 differs)
    subs x13, x12, #0
    mrs x3, nzcv            // Expected: Z=1, C=1

    brk #0
