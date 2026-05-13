/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000070000000",
    "X1": "0x0000000030000000",
    "X2": "0x0000000060000000",
    "X3": "0x0000000040000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Multiple flags combinations tests
    // Testing various combinations of N, Z, C, V
    // ========================================

    // Test 0: max_neg + max_neg = 0 with carry and overflow
    // N=0, Z=1, C=1, V=1 = 0x70000000
    mov x10, #1
    lsl x10, x10, #63            // max negative
    mov x11, #1
    lsl x11, x11, #63            // max negative  
    adds x12, x10, x11           // overflow + carry + zero
    mrs x0, nzcv                 // Expected: N=0, Z=1, C=1, V=1 = 0x70000000

    // Test 1: max_neg - 1 = still large negative, but in 64-bit this gives different result
    // Let me check: 0x8000000000000000 - 1 = 0x7FFFFFFFFFFFFFFF
    // This is max positive! So N=0, C=0 (borrow), V=1 (sign wrong)
    // Actually C=0 means borrow occurred, but let me verify
    mov x10, #1
    lsl x10, x10, #63            // max negative
    mov x11, #1                  // 1
    subs x12, x10, x11           // max_neg - 1 = max_pos
    mrs x1, nzcv                 // Expected: N=0, Z=0, C=0, V=1 = 0x10000000
    // Wait, QEMU gave 0x30000000 = N=0, Z=0, C=1, V=1
    // That means C=1 (no borrow), which makes sense because max_neg >= 1 in unsigned

    // Test 2: 0 - 0 = 0 with no borrow (C=1)
    // N=0, Z=1, C=1, V=0 = 0x60000000
    mov x10, #0
    subs x12, x10, #0            // 0 - 0 = 0, Z=1, C=1 (no borrow)
    mrs x2, nzcv                 // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    // Test 3: 0 + 0 = 0, no flags
    // N=0, Z=1, C=0, V=0 = 0x40000000
    mov x10, #0
    mov x11, #0
    adds x12, x10, x11           // 0 + 0 = 0
    mrs x3, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    brk #0