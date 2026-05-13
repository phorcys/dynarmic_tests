/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000000000000",
    "X2": "0x0000000080000000",
    "X3": "0x0000000080000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // 32-bit vs 64-bit flag behavior tests
    // ========================================

    // Test 0: 32-bit ADDS with bit 31 set
    mov w10, #0x80000000     // negative in 32-bit
    adds w11, w10, #0        // just set flags
    // N=1 (bit 31 set), Z=0, C=0, V=0
    mrs x0, nzcv             // Expected: N=1

    // Test 1: 64-bit ADDS with bit 31 set but bit 63 clear
    mov x10, #0x80000000     // positive in 64-bit
    adds x11, x10, #0        // just set flags
    // N=0 (bit 63 clear), Z=0, C=0, V=0
    mrs x1, nzcv             // Expected: all flags 0

    // Test 2: 32-bit SUBS with underflow
    mov w10, #0
    subs w11, w10, #1        // 0 - 1 = 0xFFFFFFFF
    // N=1 (bit 31 set), C=0 (borrow)
    mrs x2, nzcv             // Expected: N=1

    // Test 3: 64-bit SUBS with underflow
    mov x10, #0
    subs x11, x10, #1        // 0 - 1 = 0xFFFFFFFFFFFFFFFF
    // N=1 (bit 63 set), C=0 (borrow)
    mrs x3, nzcv             // Expected: N=1

    brk #0