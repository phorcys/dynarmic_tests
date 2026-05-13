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
    // Bit manipulation with flags (REV, RBIT)
    // ========================================

    // Test 0: REV64 then check
    movz x10, #0x1234
    movk x10, #0x5678, lsl #16
    // x10 = 0x0000000056781234
    rev x11, x10             // x11 = 0x3412785600000000
    subs x12, x11, x11
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: RBIT (reverse bits)
    mov x10, #0x80           // x10 = 0x0000000000000080
    rbit x11, x10            // x11 = 0x0100000000000000
    subs x12, x11, x11
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: REV32
    mov x10, #0x1234
    rev32 x11, x10           // reverse in 32-bit chunks
    subs x12, x11, x11
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: REV16
    mov x10, #0x1234
    rev16 x11, x10           // reverse in 16-bit chunks
    subs x12, x11, x11
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0