/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xA0000000",
    "X1": "0x20000000",
    "X2": "0xA0000000",
    "X3": "0xA0000000"
  }
}
*/
// Test: Shift operations with flags (using CMP to check results)
// CMP sets flags: N = sign bit, Z = (result == 0), C = NOT borrow, V = signed overflow

.text
.global _start
_start:
    // Test 1: LSL (Logical Shift Left) with result check
    // 1 << 31 = 0x80000000 (negative)
    mov w11, #1
    lsl w12, w11, #31    // w12 = 0x80000000
    cmp w12, #0          // Compare with 0
    // 0x80000000 - 0 = 0x80000000, N=1, Z=0, C=1, V=0 -> 0xA0000000
    mrs x0, nzcv

    // Test 2: LSR (Logical Shift Right)
    // 0x80000000 >> 1 = 0x40000000 (positive)
    mov w11, #0x80000000
    lsr w12, w11, #1     // w12 = 0x40000000
    cmp w12, #0          // Compare with 0
    // 0x40000000 - 0 = 0x40000000, N=0, Z=0, C=1, V=0 -> 0x20000000
    mrs x1, nzcv

    // Test 3: ASR (Arithmetic Shift Right) - preserves sign
    // 0x80000000 >> 1 = 0xC0000000 (sign extended, still negative)
    mov w11, #0x80000000
    asr w12, w11, #1     // w12 = 0xC0000000
    cmp w12, #0          // Compare with 0
    // 0xC0000000 - 0 = 0xC0000000, N=1, Z=0, C=1, V=0 -> 0xA0000000
    mrs x2, nzcv

    // Test 4: ROR (Rotate Right)
    // 0x00000001 ROR by 1 = 0x80000000
    mov w11, #1
    ror w12, w11, #1     // w12 = 0x80000000
    cmp w12, #0          // Compare with 0
    // 0x80000000 - 0 = 0x80000000, N=1, Z=0, C=1, V=0 -> 0xA0000000
    mrs x3, nzcv

    brk #0