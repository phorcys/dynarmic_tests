/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000090000000",
    "X1": "0x0000000070000000",
    "X2": "0x0000000030000000",
    "X3": "0x0000000090000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // 32-bit overflow edge cases
    // ========================================

    // Test 0: 32-bit overflow: max_pos + 1 = min_neg
    mov w10, #0x7FFFFFFF         // max positive 32-bit
    mov w11, #1
    adds w12, w10, w11           // overflow: becomes 0x80000000
    mrs x0, nzcv                 // Expected: N=1, Z=0, C=0, V=1 = 0x90000000

    // Test 1: 32-bit: min_neg + min_neg = 0 with overflow
    mov w10, #1
    lsl w10, w10, #31            // min negative 32-bit (0x80000000)
    adds w12, w10, w10           // 0x80000000 + 0x80000000 = 0 with overflow and carry
    mrs x1, nzcv                 // Expected: N=0, Z=1, C=1, V=1 = 0x70000000

    // Test 2: 32-bit: min_neg - 1 = max_pos 
    mov w10, #1
    lsl w10, w10, #31            // min negative
    mov w11, #1
    subs w12, w10, w11           // 0x80000000 - 1 = 0x7FFFFFFF
    // Unsigned: 0x80000000 >= 1, so no borrow (C=1)
    // Signed overflow: neg - pos = pos (sign wrong), V=1
    mrs x2, nzcv                 // Expected: N=0, Z=0, C=1, V=1 = 0x30000000

    // Test 3: 32-bit: max_pos + max_pos
    mov w10, #0x7FFFFFFF
    adds w12, w10, w10           // 0x7FFFFFFF + 0x7FFFFFFF = 0xFFFFFFFE
    // N=1 (bit 31 set), Z=0, C=0 (no carry out of bit 31), V=1 (overflow)
    mrs x3, nzcv                 // Expected: N=1, Z=0, C=0, V=1 = 0x90000000

    brk #0
