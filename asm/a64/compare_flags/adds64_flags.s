/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x40000000",
    "X1": "0x90000000",
    "X2": "0xA0000000",
    "X3": "0x80000000",
    "X4": "0x30000000"
  }
}
*/
// Test: ADDS/SUBS 64-bit - 64-bit arithmetic with flags
// Tests 64-bit NZCV flags (NZCV is always 32-bit)

.text
.global _start
_start:
    // Test 1: ADDS 64-bit zero + zero
    // 0 + 0 = 0, N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    mov x11, #0
    mov x12, #0
    adds x13, x11, x12
    mrs x0, nzcv

    // Test 2: ADDS 64-bit MAX + 1 (signed overflow)
    // 0x7FFFFFFFFFFFFFFF + 1 = 0x8000000000000000 (MIN, negative)
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov x11, #0x7FFFFFFFFFFFFFFF
    mov x12, #1
    adds x13, x11, x12
    mrs x1, nzcv

    // Test 3: ADDS 64-bit negative + negative with carry
    // -1 + -1 = -2 with carry out
    // N=1, Z=0, C=1, V=0 -> NZCV = 0xA0000000
    mov x11, #-1
    mov x12, #-1
    adds x13, x11, x12
    mrs x2, nzcv

    // Test 4: SUBS 64-bit a < b (borrow)
    // 5 - 10 = -5, N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x11, #5
    mov x12, #10
    subs x13, x11, x12
    mrs x3, nzcv

    // Test 5: SUBS 64-bit MIN - 1 (signed overflow)
    // 0x8000000000000000 - 1 = 0x7FFFFFFFFFFFFFFF (MAX, positive)
    // N=0, Z=0, C=1, V=1 -> NZCV = 0x30000000
    mov x11, #0x8000000000000000
    mov x12, #1
    subs x13, x11, x12
    mrs x4, nzcv

    brk #0