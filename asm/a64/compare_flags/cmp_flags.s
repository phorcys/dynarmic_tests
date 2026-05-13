/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x60000000",
    "X1": "0x20000000",
    "X2": "0x80000000",
    "X3": "0x30000000",
    "X4": "0x80000000",
    "X5": "0x90000000",
    "X6": "0x60000000",
    "X7": "0xA0000000"
  }
}
*/
// Test: CMP (64-bit) - Compare (SUBS without writeback)
// CMP Xn, Xm is equivalent to SUBS XZR, Xn, Xm
// Tests NZCV flags for comparison operations

.text
.global _start
_start:
    // Test 1: CMP 0, 0 -> equal
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov x10, #0
    cmp x10, #0
    mrs x0, nzcv

    // Test 2: CMP 5, 3 -> greater
    // N=0, Z=0, C=1, V=0 -> NZCV = 0x20000000
    mov x10, #5
    cmp x10, #3
    mrs x1, nzcv

    // Test 3: CMP 3, 5 -> less
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #3
    cmp x10, #5
    mrs x2, nzcv

    // Test 4: CMP MIN_SIGNED, 1 -> overflow
    // N=0, Z=0, C=1, V=1 -> NZCV = 0x30000000
    mov x10, #0x8000000000000000
    cmp x10, #1
    mrs x3, nzcv

    // Test 5: CMP 0, 1 -> less with borrow
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #0
    cmp x10, #1
    mrs x4, nzcv

    // Test 6: CMP MAX_SIGNED, -1 -> overflow
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov x10, #0x7FFFFFFFFFFFFFFF
    mov x11, #-1
    cmp x10, x11
    mrs x5, nzcv

    // Test 7: CMP same values
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov x10, #42
    cmp x10, #42
    mrs x6, nzcv

    // Test 8: CMP MAX_UNSIGNED, 0 -> huge positive
    // N=1, Z=0, C=1, V=0 -> NZCV = 0xA0000000
    mov x10, #-1
    cmp x10, #0
    mrs x7, nzcv

    brk #0