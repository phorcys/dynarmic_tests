/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x00000000A0000000",
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
    // Add/Sub with shift and flags
    // ========================================

    // Test 0: ADD with LSL shift
    mov x10, #1
    mov x11, #1
    add x12, x10, x11, lsl #4  // 1 + (1 << 4) = 17
    subs x13, x12, #17
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: ADD with LSR shift
    mov x10, #16
    mov x11, #32
    add x12, x10, x11, lsr #1  // 16 + (32 >> 1) = 16 + 16 = 32
    subs x13, x12, #32
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: SUB with ASR shift
    mov x10, #1
    lsl x10, x10, #63        // x10 = INT64_MIN (0x8000000000000000)
    mov x11, #1
    lsl x11, x11, #63        // x11 = INT64_MIN
    sub x12, x10, x11, asr #1  // INT64_MIN - (INT64_MIN >> 1)
    subs x13, x12, #0
    mrs x2, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 3: ADDS with shift
    mov x10, #0x7FFF
    mov x11, #1
    adds x12, x10, x11, lsl #16  // 0x7FFF + 0x10000 = 0x17FFF
    mov x13, #0x7FFF
    orr x13, x13, #0x10000
    subs x14, x12, x13
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0
