/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x40000000",
    "X1": "0x00000000",
    "X2": "0x80000000",
    "X3": "0x00000000",
    "X4": "0x40000000",
    "X5": "0x40000000",
    "X6": "0x80000000",
    "X7": "0x00000000"
  }
}
*/
// Test: ANDS (64-bit) - Bitwise AND and Set Flags
// ANDS only sets N and Z flags (C and V are always 0)
// N = result[63] (sign bit of result)
// Z = (result == 0) ? 1 : 0
// C = 0, V = 0 (always for logical operations)

.text
.global _start
_start:
    // Test 1: ANDS with 0 -> result is 0
    // N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    mov x10, #255
    mov x11, #0
    ands x12, x10, x11
    mrs x0, nzcv

    // Test 2: ANDS with positive result
    // 255 & 15 = 15 (positive)
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov x10, #255
    mov x11, #15
    ands x12, x10, x11
    mrs x1, nzcv

    // Test 3: ANDS with negative result (bit 63 set)
    // 0x8000000000000000 & 0x8000000000000000 = 0x8000000000000000
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #1
    lsl x10, x10, #63     // x10 = 0x8000000000000000
    mov x11, #1
    lsl x11, x11, #63     // x11 = 0x8000000000000000
    ands x12, x10, x11
    mrs x2, nzcv

    // Test 4: ANDS all bits -> same value
    // 42 & 0xFFFFFFFFFFFFFFFF = 42
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov x10, #42
    mov x11, #-1
    ands x12, x10, x11
    mrs x3, nzcv

    // Test 5: ANDS different bits -> 0
    // 0xF0 & 0x0F = 0
    // N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    mov x10, #240         // 0xF0
    mov x11, #15          // 0x0F
    ands x12, x10, x11
    mrs x4, nzcv

    // Test 6: ANDS with immediate - zero result
    // 1 & 2 = 0
    // N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    mov x10, #1
    mov x11, #2
    ands x12, x10, x11
    mrs x5, nzcv

    // Test 7: ANDS creating negative from positives
    // Two positive numbers AND'd to create negative (bit 63)
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #1
    lsl x10, x10, #63     // x10 = 0x8000000000000000
    mov x11, #-1          // x11 = 0xFFFFFFFFFFFFFFFF
    ands x12, x10, x11
    mrs x6, nzcv

    // Test 8: ANDS with full mask - same value
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov x10, #123
    mov x11, #-1
    ands x12, x10, x11
    mrs x7, nzcv

    brk #0