/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x00000000A0000000",
    "X2": "0x0000000000000000",
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
    // Logical operations with flags (ORN, EON, BIC, MVN)
    // ========================================

    // Test 0: ORN (OR NOT)
    mov x10, #0xFF
    mov x11, #0x0F
    orn x12, x10, x11        // x12 = x10 | ~x11 = 0xFF | ~0x0F
    // ~0x0F = 0xFFFFFFFFFFFFFFF0
    // 0xFF | 0xFFFFFFFFFFFFFFF0 = 0xFFFFFFFFFFFFFFFF
    subs x13, x12, x12
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: EON (Exclusive OR NOT)
    mov x10, #0xFF
    mov x11, #0xFF
    eon x12, x10, x11        // x12 = x10 ^ ~x11 = 0xFF ^ ~0xFF
    // ~0xFF = 0xFFFFFFFFFFFFFF00
    // 0xFF ^ 0xFFFFFFFFFFFFFF00 = 0xFFFFFFFFFFFFFFFF = -1
    subs x13, x12, #0
    mrs x1, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 2: BICS (bit clear and set flags)
    mov x10, #0xFF
    mov x11, #0x0F
    bics x12, x10, x11       // x12 = 0xFF & ~0x0F = 0xF0
    mrs x2, nzcv             // Expected: N=0, Z=0 (0x00000000)

    // Test 3: MVN (move NOT)
    mov x10, #0
    mvn x11, x10             // x11 = ~0 = -1
    subs x12, x11, #0
    mrs x3, nzcv             // Expected: N=1, C=1 (0xA0000000)

    brk #0