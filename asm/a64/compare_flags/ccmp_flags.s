/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000080000000",
    "X2": "0x0000000020000000",
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
    // CCMP (Conditional Compare) tests
    // CCMP Xn, Xm, #nzcv, cond
    // If condition true: compare and set flags
    // If condition false: set flags to #nzcv
    // ========================================

    // Test 0: CCMP with EQ condition (true when Z=1)
    mov x10, #5
    mov x11, #5
    cmp x10, x11              // Z=1
    ccmp x10, x11, #0, eq     // compare 5==5, set flags
    // Since EQ is true, do compare: 5-5=0, so Z=1
    mrs x0, nzcv              // Expected: Z=1, C=1

    // Test 1: CCMP with NE condition (false when Z=1)
    mov x10, #5
    mov x11, #5
    cmp x10, x11              // Z=1
    ccmp x10, x11, #8, ne     // NE is false (since Z=1), set flags to #8 (0b1000 = N=1)
    // NZCV = 0b1000 = N=1
    mrs x1, nzcv              // Expected: N=1

    // Test 2: CCMP with GT condition
    mov x10, #10
    mov x11, #5
    cmp x10, x11              // N=0, Z=0, C=1, V=0 (10 > 5)
    ccmp x10, x11, #0, gt     // GT is true, do compare
    // 10 - 5 = 5, so Z=0, N=0, C=1
    mrs x2, nzcv              // Expected: C=1, Z=0

    // Test 3: CCMP chained comparisons
    mov x10, #3
    mov x11, #5
    cmp x10, #5               // 3 < 5, so N=1 (if signed), C=0
    ccmp x10, x11, #0, lt     // LT true (N!=V), compare 3 and 5
    // 3 - 5 = -2, N=1
    mrs x3, nzcv              // Expected: N=1

    brk #0