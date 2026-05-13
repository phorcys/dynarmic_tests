/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000090000000",
    "X2": "0x0000000080000000",
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
    // ADD with extended register (ADD with shift)
    // ========================================

    // Test 0: ADDS with shifted register (LSL)
    mov x10, #1
    mov x11, #1
    adds x12, x10, x11, lsl #3  // 1 + (1 << 3) = 9
    subs x13, x12, #9
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: ADDS with LSL and overflow
    mov x10, #0x4000000000000000
    mov x11, #1
    adds x12, x10, x11, lsl #62  // 0x4000... + 0x4000... = 0x8000..., overflow
    mrs x1, nzcv             // Expected: N=1, V=1 (0x90000000)

    // Test 2: ADDS with LSR
    mov x10, #0x8000000000000000
    mov x11, #1
    adds x12, x10, x11, lsr #1  // 0x8000... + 0x4000... = 0xC000...
    mrs x2, nzcv             // Expected: N=1 (0x80000000)

    // Test 3: SUBS with ASR
    mov x10, #0x8000000000000000
    mov x11, #1
    subs x12, x10, x11, asr #1  // 0x8000... - 0xC000... (sign extended)
    mrs x3, nzcv             // Expected: N=1, C=1 (0xA0000000)

    brk #0