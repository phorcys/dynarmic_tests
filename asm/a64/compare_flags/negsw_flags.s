/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x60000000",
    "X1": "0x80000000",
    "X2": "0x00000000",
    "X3": "0x90000000",
    "X4": "0x00000000"
  }
}
*/
// Test: NEGSW (32-bit) - Negate and Set Flags
// NEGSW Wd, Wn = SUBS Wd, WZR, Wn
// result = 0 - Wn (32-bit)
// N = bit 31 of result, Z = (result == 0), C = !borrow, V = overflow

.text
.global _start
_start:
    // Test 1: NEGSW 0 = 0
    // 0 - 0 = 0, C = (0 >= 0) = 1
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov w10, #0
    negs w11, w10
    mrs x0, nzcv

    // Test 2: NEGSW positive = negative
    // 0 - 5 = -5 (32-bit: 0xFFFFFFFB)
    // C = (0 >= 5) = 0
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov w10, #5
    negs w11, w10
    mrs x1, nzcv

    // Test 3: NEGSW negative = positive
    // 0 - (-5) = 5
    // C = (0 >= 0xFFFFFFFB) = 0
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov w10, #-5
    negs w11, w10
    mrs x2, nzcv

    // Test 4: NEGSW MIN_SIGNED32 = overflow
    // 0 - 0x80000000 = 0x80000000 (same value, overflow!)
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov w10, #0x80000000
    negs w11, w10
    mrs x3, nzcv

    // Test 5: NEGSW -1 = 1
    // 0 - 0xFFFFFFFF = 1
    // C = (0 >= 0xFFFFFFFF) = 0
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov w10, #-1
    negs w11, w10
    mrs x4, nzcv

    brk #0
