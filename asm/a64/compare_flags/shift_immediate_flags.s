/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000A0000000",
    "X1": "0x0000000020000000",
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
    // Shift with immediate and flags
    // ========================================

    // Test 0: ASR with immediate (arithmetic shift right)
    mov x10, #1
    lsl x10, x10, #63        // x10 = INT64_MIN
    asr x11, x10, #4         // arithmetic shift right by 4
    // INT64_MIN >> 4 = 0xF800000000000000
    subs x12, x11, #0
    mrs x0, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 1: LSR with immediate (logical shift right)
    mov x10, #1
    lsl x10, x10, #63        // x10 = 0x8000000000000000
    lsr x11, x10, #4         // logical shift right by 4
    // 0x8000000000000000 >> 4 = 0x0800000000000000
    subs x12, x11, #0
    mrs x1, nzcv             // Expected: C=1 (0x20000000)

    // Test 2: LSL with immediate (logical shift left)
    mov x10, #1
    lsl x11, x10, #4         // x11 = 16
    subs x12, x11, #16
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: ROR with immediate (rotate right)
    mov x10, #1
    lsl x10, x10, #4         // x10 = 0x10
    ror x11, x10, #4         // rotate right by 4: 0x10 -> 0x01
    subs x12, x11, #1
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0