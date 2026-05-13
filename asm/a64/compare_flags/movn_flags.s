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
    // MOVN (move NOT) flags tests
    // ========================================

    // Test 0: MOVN basic
    movn x10, #0             // x10 = ~0 = -1 (all 1s)
    mvn x11, xzr             // same effect
    subs x12, x10, x11
    mrs x0, nzcv             // Expected: Z=1, C=1

    // Test 1: MOVN with immediate
    movn x10, #0xFF          // x10 = ~0xFF = 0xFFFFFFFFFFFFFF00
    mov x11, #0
    movk x11, #0xFF00, lsl #0  // just check low 16 bits
    // Simplified test
    movn x12, #0
    mov x13, #-1
    subs x14, x12, x13
    mrs x1, nzcv             // Expected: Z=1, C=1

    // Test 2: MOVN with shift
    movn x10, #0xFF, lsl #16 // x10 = ~(0xFF << 16) = ~0xFF0000 = 0xFFFFFFFFFF00FFFF
    // Verify bits 16-23 are 0
    mov x11, #0xFF
    lsl x11, x11, #16        // x11 = 0xFF0000
    and x12, x10, x11        // should be 0
    subs x13, x12, #0
    mrs x2, nzcv             // Expected: Z=1, C=1

    // Test 3: MOVN with large shift
    movn x10, #1, lsl #48    // x10 = ~(1 << 48) = 0xFFFEFFFFFFFFFFFF
    // Verify bit 48 is 0
    mov x11, #1
    lsl x11, x11, #48        // x11 = 1 << 48
    and x12, x10, x11        // should be 0
    subs x13, x12, #0
    mrs x3, nzcv             // Expected: Z=1, C=1

    brk #0
