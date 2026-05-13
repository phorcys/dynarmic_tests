/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x00000000A0000000",
    "X2": "0x0000000060000000",
    "X3": "0x00000000A0000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Conditional set/increment with flags
    // ========================================

    // Test 0: CSET with condition
    mov x10, #10
    cmp x10, #10             // sets Z=1 (equal)
    cset x11, eq             // x11 = 1 if Z=1
    subs x12, x11, #1
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: CSETM (conditional set mask)
    mov x10, #5
    cmp x10, #10             // 5 < 10, N=1
    csetm x11, lt            // x11 = all 1s if N!=V (less than)
    subs x12, x11, #0
    mrs x1, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 2: CSINC (conditional select increment)
    mov x10, #100
    cmp x10, #100            // sets Z=1
    mov x11, #50
    mov x12, #25
    csinc x13, x11, x12, ne  // if Z=0, x13=x11; else x13=x12+1
    // Z=1, so x13 = x12 + 1 = 26
    subs x14, x13, #26
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: CSINV (conditional select invert)
    mov x10, #0
    cmp x10, #0              // sets Z=1
    mov x11, #0
    mov x12, #0
    csinv x13, x11, x12, ne  // if Z=0, x13=x11; else x13=~x12
    // Z=1, so x13 = ~0 = -1
    subs x14, x13, #0
    mrs x3, nzcv             // Expected: N=1, C=1 (0xA0000000)

    brk #0