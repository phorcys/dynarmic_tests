/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000090000000",
    "X1": "0x0000000030000000",
    "X2": "0x0000000030000000",
    "X3": "0x0000000090000000",
    "X4": "0x0000000030000000",
    "X5": "0x0000000090000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Overflow flag tests (V flag)
    // ========================================

    // Test 0: ADDS positive overflow (32-bit)
    mov w10, #0x7FFFFFFF         // MAX positive int32
    mov w11, #1
    adds w12, w10, w11           // Overflow: MAX + 1 = MIN (negative)
    mrs x0, nzcv                 // Expected: N=1, Z=0, C=0, V=1 = 0x90000000

    // Test 1: ADDS negative overflow (32-bit)
    mov w10, #0x80000000         // MIN negative int32
    mov w11, #0xFFFFFFFF         // -1
    adds w12, w10, w11           // MIN + (-1) = MAX-1, C=1, V=1 (neg+neg=pos)
    mrs x1, nzcv                 // Expected: N=0, Z=0, C=1, V=1 = 0x30000000

    // Test 2: SUBS positive overflow (32-bit)
    mov w10, #0x80000000         // MIN negative int32
    mov w11, #1
    subs w12, w10, w11           // MIN - 1 = MAX (positive), overflow, C=1
    mrs x2, nzcv                 // Expected: N=0, Z=0, C=1, V=1 = 0x30000000

    // Test 3: SUBS negative overflow (32-bit)
    mov w10, #0x7FFFFFFF         // MAX positive int32
    mov w11, #0x80000000         // MIN negative
    subs w12, w10, w11           // MAX - MIN = MAX + MAX, overflow
    mrs x3, nzcv                 // Expected: N=1, Z=0, C=0, V=1 = 0x90000000

    // Test 4: ADDS 64-bit negative overflow
    mov x10, #1
    lsl x10, x10, #63            // 0x8000000000000000 (MIN int64)
    mov x11, #0xFFFFFFFFFFFFFFFF // -1
    adds x12, x10, x11           // MIN + (-1) = MAX-1, overflow (neg+neg=pos)
    mrs x4, nzcv                 // Expected: N=0, Z=0, C=1, V=1 = 0x30000000

    // Test 5: ADDS 64-bit positive overflow
    mov x10, #1
    lsl x10, x10, #62            // 0x4000000000000000
    mov x11, x10
    adds x12, x10, x11           // Positive + positive = negative, overflow
    mrs x5, nzcv                 // Expected: N=1, Z=0, C=0, V=1 = 0x90000000

    brk #0
