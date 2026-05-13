/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000080000000",
    "X2": "0x0000000030000000",
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
    // ROR (Rotate Right) with flags
    // ========================================

    // Test 0: ROR basic
    mov x10, #1
    lsl x10, x10, #4        // x10 = 0x10
    ror x11, x10, #4        // rotate right by 4
    subs x12, x11, #1       // result should be 1
    mrs x0, nzcv            // Expected: Z=1, C=1

    // Test 1: ROR with sign bit
    mov x10, #1
    lsl x10, x10, #63       // x10 = 0x8000000000000000
    ror x11, x10, #1        // rotate: bit 63 -> bit 0
    mov x12, #1
    mov x13, #1
    lsl x13, x13, #62       // x13 = 0x4000000000000000
    orr x12, x12, x13       // x12 = 0x4000000000000001
    subs x14, x11, x12      // x11 < x12, so negative
    mrs x1, nzcv            // Expected: N=1

    // Test 2: ROR 32 bits
    mov x10, #1
    lsl x10, x10, #31       // x10 = 0x80000000
    ror x11, x10, #32       // rotate right by 32
    subs x12, x11, x10
    mrs x2, nzcv            // Expected: C=1, V=1

    // Test 3: ROR all bits
    mov x10, #0xF
    ror x11, x10, #0        // rotate by 0 = no change
    subs x12, x11, #0xF
    mrs x3, nzcv            // Expected: Z=1, C=1

    brk #0