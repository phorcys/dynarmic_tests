/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000A0000000",
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
    // Extend operations with flags
    // ========================================

    // Test 0: SXTB (sign extend byte)
    mov w10, #0x80
    sxtb x11, w10            // sign extend: 0x80 -> 0xFFFFFFFFFFFFFF80
    subs x12, x11, #0
    mrs x0, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 1: SXTH (sign extend halfword)
    mov w10, #0x8000
    sxth x11, w10            // sign extend: 0x8000 -> 0xFFFFFFFFFFFF8000
    subs x12, x11, #0
    mrs x1, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 2: SXTW (sign extend word)
    mov w10, #1
    lsl w10, w10, #31        // w10 = 0x80000000
    sxtw x11, w10            // sign extend: 0x80000000 -> 0xFFFFFFFF80000000
    subs x12, x11, #0
    mrs x2, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 3: UXTB (zero extend byte)
    mov w10, #0xFF
    uxtb w11, w10            // zero extend: 0xFF -> 0x00000000000000FF
    subs x12, x11, #0xFF
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0
