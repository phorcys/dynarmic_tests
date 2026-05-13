/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000020000000",
    "X1": "0x00000000A0000000",
    "X2": "0x0000000060000000",
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
    // EXTR with flags tests
    // ========================================

    // Test 0: EXTR - extract from two registers
    mov x10, #1
    lsl x10, x10, #63        // x10 = 0x8000000000000000
    mov x11, #1
    lsl x11, x11, #62        // x11 = 0x4000000000000000
    extr x12, x10, x11, #1   // extract bits 1-64: x11:bit0 + x10:bits63-1
    subs x13, x12, #0
    mrs x0, nzcv             // Expected: C=1 (0x20000000)

    // Test 1: EXTR with all ones
    mov x10, #1
    neg x10, x10             // x10 = -1 (all ones)
    mov x11, #0
    extr x12, x10, x11, #32  // extract bits 32-63 from x10 into low 32 bits
    subs x13, x12, #0        // result has bit 31 set (all 0xFFFFFFFF)
    mrs x1, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 2: EXTR with zeros
    mov x10, #0
    mov x11, #0
    extr x12, x10, x11, #16
    subs x13, x12, #0
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: EXTR full merge
    mov x10, #0xFFFF
    movk x10, #0xFFFF, lsl #16
    movk x10, #0xFFFF, lsl #32
    movk x10, #0xFFFF, lsl #48  // x10 = all 1s
    mov x11, #0
    extr x12, x10, x11, #48
    subs x13, x12, #0        // result is 0xFFFF (bits 48-63 of x10)
    mrs x3, nzcv             // Expected: N=1, C=1 (0xA0000000)

    brk #0
