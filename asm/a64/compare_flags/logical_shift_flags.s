/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000060000000",
    "X3": "0x0000000040000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Logical with shift and flags
    // ========================================

    // Test 0: AND with LSL shift
    mov x10, #0xFF
    mov x11, #0x0F
    lsl x11, x11, #4         // x11 = 0xF0
    and x12, x10, x11        // x12 = 0xFF & 0xF0 = 0xF0
    subs x13, x12, #0xF0
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: ORR with LSL shift
    mov x10, #0x0F
    mov x11, #0xF0
    orr x12, x10, x11        // x12 = 0x0F | 0xF0 = 0xFF
    subs x13, x12, #0xFF
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: EOR with LSL shift
    mov x10, #0xFF
    mov x11, #0x0F
    lsl x11, x11, #4         // x11 = 0xF0
    eor x12, x10, x11        // x12 = 0xFF ^ 0xF0 = 0x0F
    subs x13, x12, #0x0F
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: ANDS with shift
    mov x10, #0xFF00
    mov x11, #0xFF
    ands x12, x10, x11       // 0xFF00 & 0xFF = 0
    mrs x3, nzcv             // Expected: Z=1 (0x40000000)

    brk #0