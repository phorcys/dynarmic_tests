/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x40000000",
    "X1": "0x60000000",
    "X2": "0xA0000000",
    "X3": "0x90000000",
    "X4": "0x60000000",
    "X5": "0x00000000",
    "X6": "0x30000000",
    "X7": "0x70000000"
  }
}
*/
// Test: ADDSW (32-bit) - Add and Set Flags
// N = bit 31 of 32-bit result
// Z = (result == 0) ? 1 : 0
// C = unsigned overflow (carry out from bit 31)
// V = signed overflow

.text
.global _start
_start:
    // Test 1: ADDSW 0 + 0 = 0
    // N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    mov w10, #0
    mov w11, #0
    adds w12, w10, w11
    mrs x0, nzcv

    // Test 2: ADDSW -1 + 1 = 0 (32-bit wrap)
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov w10, #-1
    mov w11, #1
    adds w12, w10, w11
    mrs x1, nzcv

    // Test 3: ADDSW negative + negative = negative with carry
    // -2 + -1 = -3, N=1, Z=0, C=1, V=0 -> NZCV = 0xA0000000
    mov w10, #-2
    mov w11, #-1
    adds w12, w10, w11
    mrs x2, nzcv

    // Test 4: ADDSW overflow (MAX_SIGNED32 + 1)
    // 0x7FFFFFFF + 1 = 0x80000000 (overflow, negative result)
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov w10, #0x7FFFFFFF
    mov w11, #1
    adds w12, w10, w11
    mrs x3, nzcv

    // Test 5: ADDSW unsigned overflow (MAX_UINT32 + 1) - same as test 2
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov w10, #-1
    mov w11, #1
    adds w12, w10, w11
    mrs x4, nzcv

    // Test 6: ADDSW normal positive + positive
    // 5 + 3 = 8, N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov w10, #5
    mov w11, #3
    adds w12, w10, w11
    mrs x5, nzcv

    // Test 7: ADDSW MIN_SIGNED32 + (-1) = overflow
    // 0x80000000 + 0xFFFFFFFF = 0x7FFFFFFF (overflow, positive result)
    // N=0, Z=0, C=1, V=1 -> NZCV = 0x30000000
    mov w10, #0x80000000
    mov w11, #-1
    adds w12, w10, w11
    mrs x6, nzcv

    // Test 8: ADDSW MIN_SIGNED32 + MIN_SIGNED32
    // 0x80000000 + 0x80000000 = 0 (with carry)
    // N=0, Z=1, C=1, V=1 -> NZCV = 0x70000000
    mov w10, #0x80000000
    mov w11, #0x80000000
    adds w12, w10, w11
    mrs x7, nzcv

    brk #0