/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000020000000",
    "X1": "0x0000000020000000",
    "X2": "0x0000000000000000",
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
    // Conditional compare (CCMP/CCMN) - more tests
    // ========================================

    // Test 0: CCMP with EQ condition (pass)
    mov x10, #10
    mov x11, #10
    cmp x10, x11             // sets Z=1 (equal)
    ccmp x10, #5, #0, eq     // if Z=1, compare x10 with 5
    // x10 (10) vs 5: N=0, Z=0, C=1, V=0
    mrs x0, nzcv             // Expected: C=1 (0x20000000)

    // Test 1: CCMP with NE condition (pass)
    mov x10, #10
    mov x11, #20
    cmp x10, x11             // sets N=1 (10 < 20)
    ccmp x10, #5, #0, ne     // condition NE true (Z=0), compare x10 with 5
    // x10 (10) vs 5: N=0, Z=0, C=1, V=0
    mrs x1, nzcv             // Expected: C=1 (0x20000000)

    // Test 2: CCMN (conditional compare negative)
    mov x10, #5
    mov x11, #5
    cmp x10, x11             // sets Z=1 (equal)
    ccmn x10, #3, #0, eq     // if Z=1, compare x10 with -3
    // CCMN: x10 - (-3) = x10 + 3
    // 5 + 3 = 8: N=0, Z=0, C=0, V=0
    mrs x2, nzcv             // Expected: 0x00000000

    // Test 3: CCMP with GE condition
    mov x10, #20
    mov x11, #10
    cmp x10, x11             // sets N=0, Z=0, C=1 (20 >= 10)
    ccmp x10, #25, #0, ge    // if GE true, compare x10 with 25
    // x10 (20) vs 25: 20 - 25 = -5, N=1, Z=0, C=0, V=0
    mrs x3, nzcv             // Expected: N=1 (0x80000000)

    brk #0