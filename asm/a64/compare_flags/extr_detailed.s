/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000060000000",
    "X3": "0x0000000060000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // EXTR (Extract register) tests
    // EXTR Xd, Xn, Xm, #lsb
    // Xd = (Xn << (64-lsb)) | (Xm >> lsb)
    // ========================================

    // Test 0: EXTR with lsb=0, returns Xm
    mov x10, #0xFF       // Xn
    mov x11, #0x34       // Xm
    extr x12, x10, x11, #0    // x12 = Xm = 0x34
    subs x13, x12, #0x34      // verify
    mrs x0, nzcv             // Expected: Z=1, C=1

    // Test 1: EXTR with lsb=56
    // Xd = (Xn << 8) | (Xm >> 56)
    mov x10, #0xFF       // Xn
    mov x11, #0x34       // Xm
    extr x12, x10, x11, #56
    mov x13, #0xFF
    lsl x13, x13, #8     // x13 = 0xFF00
    subs x14, x12, x13        // verify
    mrs x1, nzcv             // Expected: Z=1, C=1

    // Test 2: EXTR with lsb=32
    // Xd = (Xn << 32) | (Xm >> 32)
    mov x10, #0xAB       // Xn
    mov x11, #0xCD       // Xm
    extr x12, x10, x11, #32
    // Xn << 32 = 0xAB00000000
    // Xm >> 32 = 0
    // Result = 0xAB00000000
    mov x13, #0xAB
    lsl x13, x13, #32
    subs x14, x12, x13        // verify
    mrs x2, nzcv             // Expected: Z=1, C=1

    // Test 3: EXTR with both registers contributing
    // Xn = 0xAB (bits 0-7)
    // Xm = 0xCD00000000000000 (bits 56-63)
    // lsb = 8
    // Xd = (Xn << 56) | (Xm >> 8) = 0xAB00000000000000 | 0x00CD000000000000
    //    = 0xABCD000000000000
    mov x10, #0xAB       // Xn
    mov x11, #0xCD
    lsl x11, x11, #56    // Xm = 0xCD00000000000000
    extr x12, x10, x11, #8
    
    mov x13, #0xAB
    lsl x13, x13, #56    // x13 = 0xAB00000000000000
    mov x14, #0xCD
    lsl x14, x14, #48    // x14 = 0x00CD000000000000
    orr x13, x13, x14    // x13 = 0xABCD000000000000
    subs x14, x12, x13        // verify
    mrs x3, nzcv             // Expected: Z=1, C=1

    brk #0
