/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000A0000000",
    "X1": "0x0000000060000000",
    "X2": "0x00000000A0000000",
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
    // Move with NOT (MVN)
    // ========================================

    // Test 0: MVN from zero
    mov x10, #0
    mvn x11, x10             // x11 = ~0 = -1
    subs x12, x11, #0
    mrs x0, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 1: MVN from all ones
    mov x10, #1
    neg x10, x10             // x10 = -1 (all ones)
    mvn x11, x10             // x11 = ~(-1) = 0
    subs x12, x11, #0
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: MVN with shift
    mov x10, #1
    mvn x11, x10, lsl #4     // x11 = ~(1 << 4) = ~0x10
    subs x12, x11, #0
    mrs x2, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 3: MOVN (move negative)
    movn x10, #0xFF, lsl #16  // x10 = ~(0xFF << 16) = 0xFFFFFFFFFF00FFFF
    subs x11, x10, #0
    mrs x3, nzcv             // Expected: N=1, C=1 (0xA0000000)

    brk #0