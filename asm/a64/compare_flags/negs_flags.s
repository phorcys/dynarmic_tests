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
// Test: NEGS (64-bit) - Negate and Set Flags
// NEGS Xd, Xn = SUBS Xd, XZR, Xn
// result = 0 - Xn
// N = result[63], Z = (result == 0), C = !borrow (0 >= Xn), V = overflow

.text
.global _start
_start:
    // Test 1: NEGS 0 = 0
    // 0 - 0 = 0, C = (0 >= 0) = 1
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov x10, #0
    negs x11, x10
    mrs x0, nzcv

    // Test 2: NEGS positive = negative
    // 0 - 5 = -5, C = (0 >= 5) = 0
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #5
    negs x11, x10
    mrs x1, nzcv

    // Test 3: NEGS negative = positive
    // 0 - (-5) = 5, C = (0 >= 0xFFFFFFFFFFFFFFFB) = 0
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov x10, #-5
    negs x11, x10
    mrs x2, nzcv

    // Test 4: NEGS MIN_SIGNED64 = overflow
    // 0 - 0x8000000000000000 = 0x8000000000000000
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov x10, #1
    lsl x10, x10, #63   // x10 = MIN_SIGNED64
    negs x11, x10
    mrs x3, nzcv

    // Test 5: NEGS -1 = 1 (with borrow)
    // 0 - 0xFFFFFFFFFFFFFFFF = 1
    // C = (0 >= 0xFFFFFFFFFFFFFFFF) = 0
    // result = 1, N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov x10, #-1
    negs x11, x10
    mrs x4, nzcv

    brk #0