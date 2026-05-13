/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x00000000A0000000",
    "X2": "0x00000000A0000000",
    "X3": "0x0000000040000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Logical with immediate and flags
    // ========================================

    // Test 0: ANDS with immediate (bit 31 set in 32-bit)
    mov w10, #0x80000000
    ands w11, w10, #0x80000000   // bit 31 set, N=1, C=0
    mrs x0, nzcv             // Expected: N=1 (0x80000000)

    // Test 1: ORRS with immediate
    mov x10, #0
    orr x11, x10, #0x8000000000000000
    subs x12, x11, #0        // check result
    mrs x1, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 2: EORS with immediate
    mov x10, #0
    eor x11, x10, #0xFFFFFFFFFFFFFF00   // valid bitmask immediate
    subs x12, x11, #0
    mrs x2, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 3: ANDS with zero result
    mov x10, #0xFF
    ands x11, x10, #0xFFFFFF00   // 0xFF AND 0xFFFFFF00 = 0, Z=1
    mrs x3, nzcv             // Expected: Z=1 (0x40000000)

    brk #0