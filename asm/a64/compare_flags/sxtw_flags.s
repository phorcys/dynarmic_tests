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
    // SXTW (sign-extend word to doubleword)
    // SXTW extends the full 32-bit W register
    // ========================================

    // Test 0: SXTW with positive value
    mov w10, #0xFF           // positive byte
    sxtw x11, w10            // sign-extend word
    // x11 = 0x00000000000000FF (bit 31 = 0, no sign extension)
    subs x12, x11, #0xFF
    mrs x0, nzcv             // Expected: Z=1, C=1

    // Test 1: SXTW with negative value (full 32-bit negative)
    mov w10, #-1             // 0xFFFFFFFF
    sxtw x11, w10            // sign-extend word
    // x11 = 0xFFFFFFFFFFFFFFFF = -1
    mov x12, #-1
    subs x13, x11, x12
    mrs x1, nzcv             // Expected: Z=1, C=1

    // Test 2: SXTW with 32-bit negative
    mov w10, #-128           // 0xFFFFFF80
    sxtw x11, w10            // sign-extend
    // x11 = 0xFFFFFFFFFFFFFF80 = -128
    mov x12, #-128
    subs x13, x11, x12
    mrs x2, nzcv             // Expected: Z=1, C=1

    // Test 3: SXTW with zero
    mov w10, #0
    sxtw x11, w10            // sign-extend word
    // x11 = 0
    subs x12, x11, #0
    mrs x3, nzcv             // Expected: Z=1, C=1

    brk #0