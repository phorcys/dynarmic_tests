/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000080000000",
    "X2": "0x0000000020000000",
    "X3": "0x0000000030000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // CMP (Compare) - alias for SUBS with XZR
    // ========================================

    // Test 0: CMP equal
    mov x10, #42
    cmp x10, #42            // 42 - 42 = 0
    mrs x0, nzcv            // Expected: Z=1, C=1

    // Test 1: CMP less than (unsigned)
    mov x10, #5
    mov x11, #10
    cmp x10, x11            // 5 - 10 = -5 (borrow)
    mrs x1, nzcv            // Expected: N=1

    // Test 2: CMP greater than (signed)
    mov x10, #10
    mov x11, #5
    cmp x10, x11            // 10 - 5 = 5
    mrs x2, nzcv            // Expected: C=1

    // Test 3: CMP with negative result
    mov x10, #1
    lsl x10, x10, #63       // x10 = INT64_MIN
    mov x11, #1
    cmp x10, x11            // INT64_MIN - 1 = overflow
    mrs x3, nzcv            // Expected: N=1, V=1

    brk #0