/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x40000000",
    "X1": "0x00000000",
    "X2": "0x80000000",
    "X3": "0x90000000",
    "X4": "0x60000000",
    "X5": "0x00000000",
    "X6": "0x30000000",
    "X7": "0x90000000"
  }
}
*/
// Test: CMN (64-bit) - Compare Negative (ADDS without writeback)
// CMN Xn, Xm is equivalent to ADDS XZR, Xn, Xm
// Tests NZCV flags for negative comparison operations

.text
.global _start
_start:
    // Test 1: CMN 0, 0 -> 0 + 0 = 0
    // N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    mov x10, #0
    cmn x10, #0
    mrs x0, nzcv

    // Test 2: CMN 1, 2 -> 1 + 2 = 3 (positive)
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov x10, #1
    cmn x10, #2
    mrs x1, nzcv

    // Test 3: CMN -2, 1 -> -2 + 1 = -1 (negative)
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #-2
    cmn x10, #1
    mrs x2, nzcv

    // Test 4: CMN MAX_SIGNED, 1 -> overflow
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov x10, #0x7FFFFFFFFFFFFFFF
    cmn x10, #1
    mrs x3, nzcv

    // Test 5: CMN -1, 1 -> 0xFFFFFFFFFFFFFFFF + 1 = 0
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov x10, #-1
    cmn x10, #1
    mrs x4, nzcv

    // Test 6: CMN 5, 3 -> 8 (positive, no flags)
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov x10, #5
    cmn x10, #3
    mrs x5, nzcv

    // Test 7: CMN MIN_SIGNED, -1 -> overflow
    // 0x8000000000000000 + 0xFFFFFFFFFFFFFFFF = 0x7FFFFFFFFFFFFFFF
    // N=0, Z=0, C=1, V=1 -> NZCV = 0x30000000
    mov x10, #0x8000000000000000
    mov x11, #-1
    cmn x10, x11
    mrs x6, nzcv

    // Test 8: CMN large positive + large positive -> overflow
    // 0x4000000000000000 + 0x5000000000000000 = 0x9000000000000000
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov x10, #0x4000000000000000
    mov x11, #0x5000000000000000
    cmn x10, x11
    mrs x7, nzcv

    brk #0