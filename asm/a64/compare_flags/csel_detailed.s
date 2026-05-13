/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x00000000A0000000",
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
    // Conditional select (CSEL) detailed
    // ========================================

    // Test 0: CSEL with EQ condition
    mov x10, #10
    mov x11, #20
    adds x12, x10, #0        // 10, flags: Z=0
    csel x13, x10, x11, eq   // if EQ (Z=1), select x10, else x11
                             // Z=0, so select x11 = 20
    subs x14, x13, #20
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: CSEL with NE condition
    mov x10, #10
    mov x11, #20
    adds x12, x10, #0        // 10, flags: Z=0
    csel x13, x10, x11, ne   // if NE (Z=0), select x10, else x11
                             // Z=0, so select x10 = 10
    subs x14, x13, #10
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: CSEL with MI condition (negative)
    mov x10, #0x8000000000000000
    mov x11, #20
    adds x12, x10, #0        // flags: N=1
    csel x13, x10, x11, mi   // if MI (N=1), select x10
    subs x14, x13, #0        // x10 is negative
    mrs x2, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 3: CSEL with PL condition (positive or zero)
    mov x10, #10
    mov x11, #0x8000000000000000
    adds x12, x10, #0        // flags: N=0
    csel x13, x10, x11, pl   // if PL (N=0), select x10
    subs x14, x13, #10
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0