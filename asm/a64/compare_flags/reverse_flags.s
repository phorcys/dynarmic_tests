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
    // RBIT/REV/REV16/REV32/REV64 flags tests
    // These do NOT set flags, but we verify results with SUBS
    // ========================================

    // Test 0: RBIT (reverse bits)
    mov x10, #0xFF
    rbit x12, x10           // 0xFF reversed = 0xFF00000000000000
    mov x13, #0xFF
    lsl x13, x13, #56       // 0xFF00000000000000
    subs x14, x12, x13
    mrs x0, nzcv            // Expected: Z=1, C=1

    // Test 1: REV16 (reverse bytes in 16-bit halfwords)
    // 简化：使用 movz 构造值
    movz x10, #0x1234
    rev16 x12, x10          // swap bytes in each 16-bit halfword
    // 0x1234 -> 0x3412 (only low 16 bits)
    movz x13, #0x3412
    subs x14, x12, x13
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: REV32 (reverse bytes in 32-bit words)
    // 使用简单值
    mov x10, #0x12
    lsl x10, x10, #8        // x10 = 0x1200
    rev32 x12, x10          // swap bytes in each 32-bit word
    // 0x1200 -> 0x00120000 (reversed and extended)
    mov x13, #0x12
    lsl x13, x13, #16       // x13 = 0x120000
    subs x14, x12, x13
    mrs x2, nzcv            // Expected: Z=1, C=1

    // Test 3: REV (same as REV64)
    mov x10, #0xFF
    rev x12, x10            // 0xFF reversed = 0xFF00000000000000
    mov x13, #0xFF
    lsl x13, x13, #56
    subs x14, x12, x13
    mrs x3, nzcv            // Expected: Z=1, C=1

    brk #0
