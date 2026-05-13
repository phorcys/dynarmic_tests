/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000080000000",
    "X2": "0x0000000020000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000030000000",
    "X5": "0x0000000000000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Shifted register flags tests
    // ========================================

    // Test 0: ADDS with LSL shift
    mov x10, #1
    mov x11, #1
    adds x12, x10, x11, lsl #3   // 1 + (1 << 3) = 1 + 8 = 9
    mrs x0, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 1: ADDS with LSL shift causing negative (overflow)
    mov x10, #1
    lsl x10, x10, #62            // 0x4000000000000000
    mov x11, x10
    adds x12, x10, x11, lsl #1   // 0x400000... + 0x800000... = overflow, N=1
    mrs x1, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 2: SUBS with LSR shift
    mov x10, #0x100
    mov x11, #1
    subs x12, x10, x11, lsr #4   // 0x100 - (1 >> 4) = 0x100 - 0 = 0x100
    mrs x2, nzcv                 // Expected: N=0, Z=0, C=1, V=0 = 0x20000000

    // Test 3: ANDS with LSL shift
    mov x10, #0xFF
    mov x11, #0xF
    ands x12, x10, x11, lsl #4   // 0xFF & 0xF0 = 0xF0
    mrs x3, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 4: SUBS with ASR shift (arithmetic right)
    mov x10, #1
    lsl x10, x10, #63            // Negative value (MIN int64)
    mov x11, #2
    subs x12, x10, x11, asr #1   // MIN - (2 >> 1) = MIN - 1 = MAX, overflow
    mrs x4, nzcv                 // Expected: N=0, Z=0, C=1, V=1 = 0x30000000

    // Test 5: ADDS with shift by 0
    mov x10, #100
    mov x11, #200
    adds x12, x10, x11, lsl #0   // Same as adds x12, x10, x11
    mrs x5, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    brk #0
