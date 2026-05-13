/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x20000000",
    "X1": "0x80000000",
    "X2": "0x20000000",
    "X3": "0x90000000"
  }
}
*/
// Test: SUBS with shift (64-bit)
// SUBS Xd, Xn, Xm, LSL #n
// SUBS Xd, Xn, Xm, LSR #n

.text
.global _start
_start:
    // Test 1: SUBS with LSL #4
    // 32 - (1 << 4) = 32 - 16 = 16
    // N=0, Z=0, C=1, V=0 -> NZCV = 0x20000000
    mov x10, #32
    mov x11, #1
    subs x12, x10, x11, lsl #4
    mrs x0, nzcv

    // Test 2: SUBS with LSL causing borrow
    // 8 - (1 << 4) = 8 - 16 = -8
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov x10, #8
    mov x11, #1
    subs x12, x10, x11, lsl #4
    mrs x1, nzcv

    // Test 3: SUBS with LSR
    // 0x100 - (0x200 >> 4) = 0x100 - 0x20 = 0xE0
    // N=0, Z=0, C=1, V=0 -> NZCV = 0x20000000
    mov x10, #0x100
    mov x11, #0x200
    subs x12, x10, x11, lsr #4
    mrs x2, nzcv

    // Test 4: SUBS with ASR causing overflow
    // MAX_SIGNED - (-1 >> 0) = MAX_SIGNED - (-1) = overflow
    // 0x7FFFFFFFFFFFFFFF - 0xFFFFFFFFFFFFFFFF = 0x8000000000000000
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    mov x10, #0x7FFFFFFFFFFFFFFF
    mov x11, #-1
    subs x12, x10, x11, asr #0
    mrs x3, nzcv

    brk #0