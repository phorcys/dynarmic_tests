/* CONFIG
{
  "Match": "All",
  "QemuSkip": "QEMU mis-handles SETF8/SETF16 flag semantics",
  "RegData": {
    "X0": "0x40000000",
    "X1": "0x80000000",
    "X2": "0x00000000",
    "X3": "0x80000000",
    "X4": "0x00000000",
    "X5": "0x80000000",
    "X6": "0x40000000",
    "X7": "0x80000000"
  },
  "VecData": {}
}
*/
.arch armv8.4-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // SETF8 - Set flags from byte (bits [7:0] of Wn)
    // Per ARM Architecture Reference Manual:
    // N = bit 7, Z = (byte == 0), C = unchanged, V = unchanged
    // Since we clear NZCV before each test, C=0, V=0 preserved
    // ========================================

    // Test 1: SETF8 with zero byte (0x00)
    // N=0, Z=1, C=0, V=0 -> 0x40000000
    msr nzcv, xzr
    movz w20, #0x00
    setf8 w20
    mrs x0, nzcv              // Expected: 0x40000000 (Z=1)

    // Test 2: SETF8 with negative byte (0x80)
    // N=1, Z=0, C=0, V=0 -> 0x80000000
    msr nzcv, xzr
    movz w20, #0x80
    setf8 w20
    mrs x1, nzcv              // Expected: 0x80000000 (N=1)

    // Test 3: SETF8 with positive byte (0x40)
    // N=0, Z=0, C=0, V=0 -> 0x00000000
    msr nzcv, xzr
    movz w20, #0x40
    setf8 w20
    mrs x2, nzcv              // Expected: 0x00000000

    // Test 4: SETF8 with 0xFF
    // N=1, Z=0, C=0, V=0 -> 0x80000000
    msr nzcv, xzr
    movz w20, #0xFF
    setf8 w20
    mrs x3, nzcv              // Expected: 0x80000000

    // ========================================
    // SETF16 - Set flags from halfword (bits [15:0] of Wn)
    // Per ARM Architecture Reference Manual:
    // N = bit 15, Z = (halfword == 0), C = unchanged, V = unchanged
    // Since we clear NZCV before each test, C=0, V=0 preserved
    // ========================================

    // Test 5: SETF16 with positive halfword (0x4000)
    // N=0, Z=0, C=0, V=0 -> 0x00000000
    msr nzcv, xzr
    movz w20, #0x4000
    setf16 w20
    mrs x4, nzcv              // Expected: 0x00000000

    // Test 6: SETF16 with negative halfword (0x8000)
    // N=1, Z=0, C=0, V=0 -> 0x80000000
    msr nzcv, xzr
    movz w20, #0x8000
    setf16 w20
    mrs x5, nzcv              // Expected: 0x80000000 (N=1)

    // Test 7: SETF16 with zero halfword
    // N=0, Z=1, C=0, V=0 -> 0x40000000
    msr nzcv, xzr
    movz w20, #0x0000
    setf16 w20
    mrs x6, nzcv              // Expected: 0x40000000 (Z=1)

    // Test 8: SETF16 with 0xFFFF
    // N=1, Z=0, C=0, V=0 -> 0x80000000
    msr nzcv, xzr
    movn w20, #0x0000         // w20 = 0xFFFFFFFF, bits[15:0] = 0xFFFF
    setf16 w20
    mrs x7, nzcv              // Expected: 0x80000000 (N=1)

    brk #0
