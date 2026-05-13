/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000C0000000",
    "X1": "0x00000000C0000000",
    "X2": "0x00000000C0000000",
    "X3": "0x00000000C0400000",
    "X4": "0x00000000C0000000",
    "X5": "0x00000000C0000000",
    "X6": "0x00000000C0400000",
    "X7": "0x00000000C0000000"
  }
}
*/
.text
.global _start
_start:
    // Test FPCR rounding modes with negative number
    // Test value: -2.5 = 0xC0200000
    //
    // Rounding modes for -2.5:
    // RNE: -2.5 -> -2.0 (tie to even)
    // RUP: -2.5 -> -2.0 (toward +inf, i.e., -2 > -2.5)
    // RDN: -2.5 -> -3.0 (toward -inf, i.e., -3 < -2.5)
    // RTZ: -2.5 -> -2.0 (toward zero)

    ldr w8, =0xC0200000
    fmov s0, w8          // s0 = -2.5

    // Save original FPCR
    mrs x9, fpcr

    // ==========================================
    // Part 1: Test explicit rounding instructions
    // ==========================================

    frintn s1, s0        // RNE: -2.5 -> -2.0 = 0xC0000000
    frintz s2, s0        // RTZ: -2.5 -> -2.0 = 0xC0000000
    frintp s3, s0        // RUP: -2.5 -> -2.0 = 0xC0000000
    frintm s4, s0        // RDN: -2.5 -> -3.0 = 0xC0400000

    mov x0, v1.d[0]
    mov x1, v2.d[0]
    mov x2, v3.d[0]
    mov x3, v4.d[0]

    // ==========================================
    // Part 2: Test FPCR.RMode + frinti
    // ==========================================

    // RNE (bits 23:22 = 00)
    bic x10, x9, #(3 << 22)
    msr fpcr, x10
    frinti s5, s0
    mov x4, v5.d[0]      // -2.0

    // RUP (bits 23:22 = 01)
    bic x10, x9, #(3 << 22)
    orr x10, x10, #(1 << 22)
    msr fpcr, x10
    frinti s5, s0
    mov x5, v5.d[0]      // -2.0

    // RDN (bits 23:22 = 10)
    bic x10, x9, #(3 << 22)
    orr x10, x10, #(2 << 22)
    msr fpcr, x10
    frinti s5, s0
    mov x6, v5.d[0]      // -3.0

    // RTZ (bits 23:22 = 11)
    bic x10, x9, #(3 << 22)
    orr x10, x10, #(3 << 22)
    msr fpcr, x10
    frinti s5, s0
    mov x7, v5.d[0]      // -2.0

    msr fpcr, x9
    brk #0