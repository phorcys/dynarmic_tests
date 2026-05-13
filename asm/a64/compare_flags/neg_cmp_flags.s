/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000040000000",
    "X2": "0x0000000080000000",
    "X3": "0x0000000060000000",
    "X4": "0x0000000060000000",
    "X5": "0x0000000080000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000040000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // NEG/CMP aliases (NEG is alias for SUB with ZR)
    // ========================================

    // Test 0: NEG X10, X11 -> X10 = -1, N=1
    mov x11, #1
    neg x10, x11
    adds x12, x10, xzr            // Check flags
    mrs x0, nzcv                  // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 1: NEG X10, XZR -> X10 = 0, Z=1
    neg x10, xzr
    adds x12, x10, xzr
    mrs x1, nzcv                  // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 2: NEGS X10, X11 -> X10 = -1, flags set, C=0
    mov x11, #1
    negs x10, x11
    mrs x2, nzcv                  // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 3: NEGS X10, XZR -> X10 = 0, Z=1, C=1
    negs x10, xzr
    mrs x3, nzcv                  // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    // Test 4: CMP X10, #0 -> Z=1, C=1 (0-0=0)
    mov x10, #0
    cmp x10, #0
    mrs x4, nzcv                  // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    // Test 5: CMP X10, #1 -> N=1, C=0 (0-1=-1, borrow)
    mov x10, #0
    cmp x10, #1
    mrs x5, nzcv                  // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 6: CMN X10, #1 -> N=0, Z=0, C=0 (0+1=1)
    mov x10, #0
    cmn x10, #1
    mrs x6, nzcv                  // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 7: CMN X10, #0 -> Z=1 (0+0=0)
    mov x10, #0
    cmn x10, #0
    mrs x7, nzcv                  // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    brk #0
