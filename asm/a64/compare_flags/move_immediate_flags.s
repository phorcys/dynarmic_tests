/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x00000000A0000000",
    "X2": "0x00000000A0000000",
    "X3": "0x0000000020000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // MOV with flags tests
    // ========================================

    // Test 0: MOV to register, then check flags
    mov x10, #0
    subs x11, x10, #0        // 0 - 0 = 0
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: MOVN (move negative)
    movn x10, #0             // x10 = 0xFFFFFFFFFFFFFFFF
    subs x11, x10, #0        // 0xFFFFFFFFFFFFFFFF is negative, N=1
    mrs x1, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 2: MOVZ (move with zero)
    movz x10, #0x8000, lsl #48  // x10 = 0x8000000000000000
    subs x11, x10, #0        // negative, N=1
    mrs x2, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 3: MOVK (move with keep)
    mov x10, #0
    movk x10, #0x1234, lsl #0   // x10 = 0x1234
    subs x11, x10, #0        // positive, C=1
    mrs x3, nzcv             // Expected: C=1 (0x20000000)

    brk #0