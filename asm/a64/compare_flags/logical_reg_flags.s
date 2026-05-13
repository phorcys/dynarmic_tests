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
    // AND/ORR/EOR/ORN (register) flags tests
    // These do NOT set flags, but we verify results with SUBS
    // ========================================

    // Test 0: AND basic
    mov x10, #0xFF
    mov x11, #0x0F
    and x12, x10, x11        // 0xFF & 0x0F = 0x0F
    subs x13, x12, #0x0F
    mrs x0, nzcv             // Expected: Z=1, C=1

    // Test 1: ORR basic
    mov x10, #0xF0
    mov x11, #0x0F
    orr x12, x10, x11        // 0xF0 | 0x0F = 0xFF
    subs x13, x12, #0xFF
    mrs x1, nzcv             // Expected: Z=1, C=1

    // Test 2: EOR basic
    mov x10, #0xFF
    mov x11, #0x0F
    eor x12, x10, x11        // 0xFF ^ 0x0F = 0xF0
    subs x13, x12, #0xF0
    mrs x2, nzcv             // Expected: Z=1, C=1

    // Test 3: ORN basic (OR with NOT)
    mov x10, #0xF0
    mov x11, #0x0F
    orn x12, x10, x11        // 0xF0 | (~0x0F) = 0xF0 | 0xFFFFFFFFFFFFFFF0 = 0xFFFFFFFFFFFFFFF0
    // In 64-bit: 0xF0 | 0xFFFFFFFFFFFFFFF0 = 0xFFFFFFFFFFFFFFF0
    // Simplify: just check bit 4-7 are set
    mov x13, #0xF0
    and x14, x12, x13        // check low 8 bits
    subs x15, x14, #0xF0
    mrs x3, nzcv             // Expected: Z=1, C=1

    brk #0
