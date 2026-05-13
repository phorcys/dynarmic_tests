/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000000000000",
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
    // NEGS (Negate and set flags) tests
    // NEGS Xd, Xn: Xd = 0 - Xn, sets flags
    // For SUBS, C = NOT borrow (C=1 means no borrow)
    // ========================================

    // Test 0: NEGS of positive
    mov x10, #42
    negs x11, x10                // 0 - 42 = -42, negative
    mrs x0, nzcv                 // Expected: N=1, Z=0, C=0 (borrow), V=0 = 0x80000000

    // Test 1: NEGS of negative (as large unsigned)
    // -42 as signed = huge unsigned
    // 0 - huge_unsigned requires borrow, but result is small positive
    mov x10, #42
    neg x10, x10                 // x10 = -42 (0xFFFFFFFFFFFFFFD6)
    negs x11, x10                // 0 - 0xFFFF...D6 = 0x2A = 42
    // In unsigned: 0 < huge_unsigned, so borrow (C=0)
    // Result is 42, positive, N=0
    mrs x1, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 2: NEGS of zero
    mov x10, #0
    negs x11, x10                // 0 - 0 = 0, Z=1, C=1 (no borrow: 0 >= 0)
    mrs x2, nzcv                 // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    // Test 3: NEGS of max negative (overflow)
    mov x10, #1
    lsl x10, x10, #63            // max negative (0x8000...0000)
    negs x11, x10                // 0 - max_neg = overflow, result is max_neg
    // Overflow because positive zero minus negative gives negative result
    mrs x3, nzcv                 // Expected: N=1, Z=0, C=0, V=1 = 0x90000000

    brk #0