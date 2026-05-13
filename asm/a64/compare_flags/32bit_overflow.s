/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000080000000",
    "X2": "0x0000000060000000",
    "X3": "0x0000000090000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // 32-bit operations with flags
    // ========================================

    // Test 0: 32-bit ADDS (zero extension)
    mov w10, #0xFFFFFFFF
    mov w11, #1
    adds w12, w10, w11       // 0xFFFFFFFF + 1 = 0 (32-bit), carry
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: 32-bit SUBS (borrow)
    mov w10, #0
    mov w11, #1
    subs w12, w10, w11       // 0 - 1 = 0xFFFFFFFF, C=0 (borrow), N=1
    mrs x1, nzcv             // Expected: N=1, C=0 (0x80000000)

    // Test 2: 32-bit CMP
    mov w10, #100
    cmp w10, #100            // 100 - 100 = 0
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: 32-bit overflow detection
    mov w10, #0x7FFFFFFF     // INT32_MAX
    mov w11, #1
    adds w12, w10, w11       // INT32_MAX + 1 = 0x80000000, N=1, V=1
    mrs x3, nzcv             // Expected: N=1, V=1 (0x90000000)

    brk #0