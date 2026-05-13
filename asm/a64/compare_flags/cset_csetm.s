/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
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
    // Conditional set (CSET) and conditional set mask (CSETM)
    // ========================================

    // Test 0: CSET with true condition
    mov x10, #5
    mov x11, #5
    cmp x10, x11            // Z=1
    cset x12, eq            // if EQ, x12 = 1
    subs x13, x12, #1
    mrs x0, nzcv            // Expected: Z=1, C=1

    // Test 1: CSET with false condition
    mov x10, #5
    mov x11, #3
    cmp x10, x11            // Z=0
    cset x12, eq            // if EQ (false), x12 = 0
    subs x13, x12, #0
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: CSETM with true condition
    mov x10, #10
    mov x11, #5
    cmp x10, x11            // GT condition
    csetm x12, gt           // if GT, x12 = all 1s (0xFFFFFFFFFFFFFFFF)
    subs x13, x12, #0       // result is negative
    mrs x2, nzcv            // Expected: N=1

    // Test 3: CSETM with false condition
    mov x10, #5
    mov x11, #10
    cmp x10, x11            // LT condition
    csetm x12, gt           // if GT (false), x12 = 0
    subs x13, x12, #0
    mrs x3, nzcv            // Expected: Z=1, C=1

    brk #0
