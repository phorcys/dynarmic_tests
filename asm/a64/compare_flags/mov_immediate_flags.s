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
    // MOV/MOVZ/MOVK/MOVN flags tests
    // These do NOT set flags, but we verify results with SUBS
    // ========================================

    // Test 0: MOV with immediate
    mov x10, #42
    subs x11, x10, #42
    mrs x0, nzcv             // Expected: Z=1, C=1

    // Test 1: MOVZ
    movz x10, #0xFF
    subs x11, x10, #0xFF
    mrs x1, nzcv             // Expected: Z=1, C=1

    // Test 2: MOVZ with shift
    movz x10, #0xFF, lsl #16
    mov x11, #0xFF
    lsl x11, x11, #16
    subs x12, x10, x11
    mrs x2, nzcv             // Expected: Z=1, C=1

    // Test 3: MOVK (keep previous)
    movz x10, #0xFF
    movk x10, #0xAB, lsl #16
    // x10 = 0x00AB00FF
    movz x11, #0xFF
    movk x11, #0xAB, lsl #16
    subs x12, x10, x11
    mrs x3, nzcv             // Expected: Z=1, C=1

    brk #0