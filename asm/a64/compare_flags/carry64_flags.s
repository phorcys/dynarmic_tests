/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x60000000",
    "X1": "0x80000000",
    "X2": "0x20000000",
    "X3": "0x20000000"
  }
}
*/
// Test: 64-bit carry conditions
// C flag for 64-bit operations

.text
.global _start
_start:
    // Test 1: 64-bit addition with carry (UINT64_MAX + 1)
    // 0xFFFFFFFFFFFFFFFF + 1 = 0 (with carry)
    mov x11, #0xFFFFFFFF
    movk x11, #0xFFFF, lsl #16
    movk x11, #0xFFFF, lsl #32
    movk x11, #0xFFFF, lsl #48
    adds x12, x11, #1
    // N=0, Z=1, C=1, V=0 -> 0x60000000
    mrs x0, nzcv

    // Test 2: 64-bit subtraction with borrow (0 - 1)
    mov x11, #0
    subs x12, x11, #1
    // Result = 0xFFFFFFFFFFFFFFFF, N=1, Z=0, C=0, V=0 -> 0x80000000
    mrs x1, nzcv

    // Test 3: 64-bit subtraction without borrow (1 - 0)
    mov x11, #1
    subs x12, x11, #0
    // N=0, Z=0, C=1, V=0 -> 0x20000000
    mrs x2, nzcv

    // Test 4: 64-bit subtraction (0x100000000 - 1)
    // Result = 0xFFFFFFFF, N=0 (bit 63 = 0), C=1, V=0
    mov x11, #1
    movk x11, #0, lsl #16
    movk x11, #1, lsl #32  // x11 = 0x100000000
    subs x12, x11, #1
    // N=0, Z=0, C=1, V=0 -> 0x20000000
    mrs x3, nzcv

    brk #0