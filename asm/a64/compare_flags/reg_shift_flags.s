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
    // ASRV/LSLV/LSRV/RORV (Register-shifted) flags tests
    // These do NOT set flags, but we verify results with SUBS
    // ========================================

    // Test 0: LSLV (logical shift left by register)
    mov x10, #0xFF
    mov x11, #8
    lslv x12, x10, x11    // 0xFF << 8 = 0xFF00
    mov x13, #0xFF
    lsl x13, x13, #8
    subs x14, x12, x13    // verify
    mrs x0, nzcv          // Expected: Z=1, C=1

    // Test 1: LSRV (logical shift right by register)
    mov x10, #0xFF00
    mov x11, #8
    lsrv x12, x10, x11    // 0xFF00 >> 8 = 0xFF
    subs x13, x12, #0xFF
    mrs x1, nzcv          // Expected: Z=1, C=1

    // Test 2: ASRV (arithmetic shift right by register)
    mov x10, #-256        // 0x...FF00
    mov x11, #4
    asrv x12, x10, x11    // -256 >> 4 = -16 (arithmetic)
    mov x13, #-16
    subs x14, x12, x13    // verify
    mrs x2, nzcv          // Expected: Z=1, C=1

    // Test 3: RORV (rotate right by register)
    mov x10, #1
    lsl x10, x10, #31     // x10 = 0x80000000
    mov x11, #4
    rorv x12, x10, x11    // rotate right by 4
    // 0x80000000 >> 4 with wrap = 0x08000000
    mov x13, #1
    lsl x13, x13, #27     // 0x08000000
    subs x14, x12, x13    // verify
    mrs x3, nzcv          // Expected: Z=1, C=1

    brk #0