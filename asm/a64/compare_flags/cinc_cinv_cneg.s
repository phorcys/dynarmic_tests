/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x00000000A0000000",
    "X3": "0x00000000A0000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Conditional increment/decrement (CINC/CDEC)
    // CINC Xd, Xn, cond - if cond, Xd = Xn + 1, else Xd = Xn
    // CDEC Xd, Xn, cond - if cond, Xd = Xn - 1, else Xd = Xn
    // ========================================

    // Test 0: CINC with true condition
    mov x10, #5
    mov x11, #5
    cmp x10, x11            // Z=1
    cinc x12, x10, eq       // if EQ, x12 = x10 + 1 = 6
    subs x13, x12, #6
    mrs x0, nzcv            // Expected: Z=1, C=1

    // Test 1: CINC with false condition
    mov x10, #5
    mov x11, #3
    cmp x10, x11            // NE condition
    cinc x12, x10, eq       // if EQ (false), x12 = x10 = 5
    subs x13, x12, #5
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: CINV (conditional invert)
    mov x10, #0xF0
    mov x11, #5
    mov x12, #5
    cmp x11, x12            // Z=1
    cinv x13, x10, eq       // if EQ, x13 = ~x10 = 0xFFFFFFFFFFFFFF0F
    subs x14, x13, #0       // check negative
    mrs x2, nzcv            // Expected: N=1

    // Test 3: CNEG (conditional negate)
    mov x10, #42
    mov x11, #5
    mov x12, #5
    cmp x11, x12            // Z=1
    cneg x13, x10, eq       // if EQ, x13 = -x10 = -42
    subs x14, x13, #0       // check negative
    mrs x3, nzcv            // Expected: N=1

    brk #0