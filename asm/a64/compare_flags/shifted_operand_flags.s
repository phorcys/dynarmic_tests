/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000020000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000060000000",
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
    // Arithmetic with shifted register operands
    // ========================================

    // Test 0: ADD with shifted register (ASR)
    mov x10, #0x80000000
    mov x11, #1
    asr x12, x10, #4        // arithmetic shift right
    add x13, x10, x11, asr #4
    subs x14, x13, #0       // check result
    mrs x0, nzcv            // Expected: C=1

    // Test 1: SUB with shifted register (LSL)
    mov x10, #0x100
    mov x11, #1
    sub x12, x10, x11, lsl #4   // 0x100 - (1 << 4) = 0x100 - 0x10 = 0xF0
    subs x13, x12, #0xF0
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: ORR with shifted register (LSR)
    mov x10, #0xFF00
    mov x11, #0xF
    orr x12, x10, x11, lsr #4   // 0xFF00 | 0 = 0xFF00
    mov x13, #0xFF
    lsl x13, x13, #8        // x13 = 0xFF00
    subs x14, x12, x13
    mrs x2, nzcv            // Expected: Z=1, C=1

    // Test 3: EOR with shifted register (ROR)
    mov x10, #1
    lsl x10, x10, #31       // x10 = 0x80000000
    mov x11, #1
    eor x12, x10, x11, ror #31  // 0x80000000 ^ (1 ror 31) = 0x80000000 ^ 2 = 0x80000002
    mov x13, #2
    mov x14, #1
    lsl x14, x14, #31       // x14 = 0x80000000
    orr x13, x14, x13       // x13 = 0x80000002
    subs x15, x12, x13
    mrs x3, nzcv            // Expected: C=1

    brk #0