/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000080000000",
    "X2": "0x0000000080000000",
    "X3": "0x0000000000000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Sign/Zero extend with flags tests
    // Using ADDS/SUBS with extended registers
    // ========================================

    // Test 0: SXTB (sign extend byte) - positive byte
    mov w10, #0x7F               // positive byte
    sxtb x11, w10                // sign extend, still 0x7F
    adds x12, x11, #0            // just read flags
    mrs x0, nzcv                 // Expected: N=0, Z=0 = 0x00000000

    // Test 1: SXTB (sign extend byte) - negative byte
    mov w10, #0x80               // negative byte (top bit set)
    sxtb x11, w10                // sign extend to 0xFFFFFFFFFFFFFF80
    adds x12, x11, #0            // just read flags
    mrs x1, nzcv                 // Expected: N=1

    // Test 2: SXTH (sign extend halfword) - negative
    mov w10, #0x8000             // negative halfword
    sxth x11, w10                // sign extend to 0xFFFFFFFFFFFF8000
    adds x12, x11, #0            // just read flags
    mrs x2, nzcv                 // Expected: N=1

    // Test 3: UXTB (zero extend byte) - always positive
    mov w10, #0xFF               // all ones in byte
    uxtb x11, w10                // zero extend to 0x00000000000000FF
    adds x12, x11, #0            // just read flags
    mrs x3, nzcv                 // Expected: N=0, Z=0 = 0x00000000

    brk #0