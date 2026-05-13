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
    // CSINC - Conditional select increment
    // CSINC Xd, Xn, Xm, cond
    // if cond: Xd = Xn, else: Xd = Xm + 1
    // ========================================

    // Test 0: CSINC when condition true
    mov x10, #5
    mov x11, #10
    cmp x10, #5                  // EQ true
    csinc x12, x10, x11, eq      // if EQ: x12 = x10 = 5
    subs x13, x12, #5            // verify
    mrs x0, nzcv                 // Expected: Z=1, C=1

    // Test 1: CSINC when condition false
    mov x10, #5
    mov x11, #10
    cmp x10, #6                  // EQ false
    csinc x12, x10, x11, eq      // if !EQ: x12 = x11 + 1 = 11
    subs x13, x12, #11           // verify
    mrs x1, nzcv                 // Expected: Z=1, C=1

    // Test 2: CSET - alias for CSINC with ZR
    // CSET Xd, cond: if cond: Xd = 1, else: Xd = 0
    cmp xzr, xzr                 // EQ true
    cset x12, eq                 // x12 = 1
    subs x13, x12, #1            // verify
    mrs x2, nzcv                 // Expected: Z=1, C=1

    // Test 3: CSETM - alias for CSINV with ZR
    // CSETM Xd, cond: if cond: Xd = -1, else: Xd = 0
    cmp xzr, xzr                 // EQ true
    csetm x12, eq                // x12 = -1
    mvn x13, xzr                 // x13 = -1
    subs x14, x12, x13           // verify
    mrs x3, nzcv                 // Expected: Z=1, C=1

    brk #0
