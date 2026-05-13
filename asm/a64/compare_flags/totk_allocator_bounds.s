/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000000",
    "X2": "0x0000001145fe8a78",
    "X3": "0x0000001145fe8ae0",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000001",
    "X6": "0x0000001145fe8a78",
    "X7": "0x0000001145fe8ae0",
    "X8": "0x0000000000000000",
    "X9": "0x0000000000000001",
    "X10": "0x0000001145fe8a78",
    "X11": "0x0000001145fe8a98"
  }
}
*/
// TOTK-derived sequence from 0x82a33544..0x82a335d4:
//   size = max(size, 8)
//   size = (size + 7) & ~7
//   align = abs(w2)
//   current = b0 & ~(align - 1)
//   after = current + size
//   overflow = (after < current)
//   in_bounds = (b8 >= after)
// This file checks the branch-driving conditions for three representative cases.

.text
.global _start

_start:
    // Case 0: observed failing values from TOTK
    mov x12, #0x68
    mov w13, #8
    cmp x12, #8
    mov x14, #8
    csel x14, x12, x14, hi
    cmp w13, #0
    add x14, x14, #7
    and x15, x14, #0xfffffffffffffff8
    cneg w14, w13, mi
    sub w16, w14, #1
    movz x17, #0x8a78
    movk x17, #0x45fe, lsl #16
    movk x17, #0x0011, lsl #32
    bic x18, x17, x16
    add x19, x18, x15
    cmp x19, x18
    cset x0, cc
    movz x20, #0x8ad8
    movk x20, #0x45fe, lsl #16
    movk x20, #0x0011, lsl #32
    cmp x20, x19
    cset x1, cs
    mov x2, x18
    mov x3, x19

    // Case 1: end == after, should be in bounds
    mov x12, #0x68
    mov w13, #8
    cmp x12, #8
    mov x14, #8
    csel x14, x12, x14, hi
    cmp w13, #0
    add x14, x14, #7
    and x15, x14, #0xfffffffffffffff8
    cneg w14, w13, mi
    sub w16, w14, #1
    movz x17, #0x8a78
    movk x17, #0x45fe, lsl #16
    movk x17, #0x0011, lsl #32
    bic x18, x17, x16
    add x19, x18, x15
    cmp x19, x18
    cset x4, cc
    cmp x19, x19
    cset x5, cs
    mov x6, x18
    mov x7, x19

    // Case 2: misaligned base, smaller size
    mov x12, #0x20
    mov w13, #8
    cmp x12, #8
    mov x14, #8
    csel x14, x12, x14, hi
    cmp w13, #0
    add x14, x14, #7
    and x15, x14, #0xfffffffffffffff8
    cneg w14, w13, mi
    sub w16, w14, #1
    movz x17, #0x8a7f
    movk x17, #0x45fe, lsl #16
    movk x17, #0x0011, lsl #32
    bic x18, x17, x16
    add x19, x18, x15
    cmp x19, x18
    cset x8, cc
    movz x20, #0x8b20
    movk x20, #0x45fe, lsl #16
    movk x20, #0x0011, lsl #32
    cmp x20, x19
    cset x9, cs
    mov x10, x18
    mov x11, x19

    brk #0
