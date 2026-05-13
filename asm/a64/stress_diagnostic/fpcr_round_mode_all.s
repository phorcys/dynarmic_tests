/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040000000",
    "X1": "0x0000000040000000",
    "X2": "0x0000000040400000",
    "X3": "0x0000000040000000",
    "X4": "0x0000000040000000",
    "X5": "0x0000000040400000",
    "X6": "0x0000000040000000",
    "X7": "0x0000000040000000"
  }
}
*/
.text
.global _start
_start:
    // Test all FPCR rounding modes
    // FPCR.RMode bits [23:22]
    // ARM DDI 0487 encoding:
    // 00 = RNE (Round to Nearest, ties to Even)
    // 01 = RUP (Round towards Plus Infinity)
    // 10 = RDN (Round towards Minus Infinity)
    // 11 = RTZ (Round towards Zero)

    // Test value: 2.5 = 0x40200000
    ldr w8, =0x40200000
    fmov s0, w8          // s0 = 2.5

    // Save original FPCR
    mrs x9, fpcr

    // ==========================================
    // Part 1: Test explicit rounding instructions
    // frintn = RNE, frintz = RTZ, frintp = RUP, frintm = RDN
    // ==========================================

    frintn s1, s0        // RNE: 2.5 -> 2.0
    frintz s2, s0        // RTZ: 2.5 -> 2.0
    frintp s3, s0        // RUP: 2.5 -> 3.0
    frintm s4, s0        // RDN: 2.5 -> 2.0

    // Read results as X registers
    mov x0, v1.d[0]      // X0 = 0x0000000040000000 (2.0)
    mov x1, v2.d[0]      // X1 = 0x0000000040000000 (2.0)
    mov x2, v3.d[0]      // X2 = 0x0000000040400000 (3.0)
    mov x3, v4.d[0]      // X3 = 0x0000000040000000 (2.0)

    // ==========================================
    // Part 2: Test FPCR.RMode + frinti
    // frinti uses the current FPCR.RMode
    // ==========================================

    // === RNE via FPCR (bits 23:22 = 00) ===
    bic x10, x9, #(3 << 22)    // Clear RMode bits
    msr fpcr, x10
    frinti s5, s0       // RNE: 2.5 -> 2.0
    mov x4, v5.d[0]

    // === RUP via FPCR (bits 23:22 = 01) ===
    bic x10, x9, #(3 << 22)
    orr x10, x10, #(1 << 22)    // Set RMode = 01 (RUP)
    msr fpcr, x10
    frinti s5, s0       // RUP: 2.5 -> 3.0
    mov x5, v5.d[0]

    // === RDN via FPCR (bits 23:22 = 10) ===
    bic x10, x9, #(3 << 22)
    orr x10, x10, #(2 << 22)    // Set RMode = 10 (RDN)
    msr fpcr, x10
    frinti s5, s0       // RDN: 2.5 -> 2.0
    mov x6, v5.d[0]

    // === RTZ via FPCR (bits 23:22 = 11) ===
    bic x10, x9, #(3 << 22)
    orr x10, x10, #(3 << 22)    // Set RMode = 11 (RTZ)
    msr fpcr, x10
    frinti s5, s0       // RTZ: 2.5 -> 2.0
    mov x7, v5.d[0]

    // Restore FPCR
    msr fpcr, x9

    brk #0