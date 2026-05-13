/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000400000",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000C00000",
    "X3": "0x000000000000001F"
  }
}
*/
.text
.global _start
_start:
    // Test FPCR/FPSR write and read back
    // NOTE: In AArch64, FPSR does NOT include NZCV (unlike AArch32 FPSCR)
    // NZCV is accessed via the separate NZCV system register
    //
    // FPCR layout (relevant bits):
    // [23:22] RMode - Rounding Mode (00=RNE, 01=RUP, 10=RDN, 11=RTZ)
    //
    // FPSR layout (in AArch64):
    // [4:0]   Exception flags: IOC, DZC, OFC, UFC, IXC
    // [27]    QC - Saturation cumulative (for Advanced SIMD)
    // NOTE: NZCV is NOT in FPSR for AArch64!

    // Save original values
    mrs x4, fpcr
    mrs x5, fpsr

    // ==========================================
    // Test 1: FPCR RMode write/read (set RUP=01)
    // ==========================================

    bic x6, x4, #(3 << 22)    // Clear RMode
    orr x6, x6, #(1 << 22)    // Set RMode = 01 (RUP)
    msr fpcr, x6
    mrs x0, fpcr
    and x0, x0, #(3 << 22)    // Extract RMode, expect 0x00400000

    // ==========================================
    // Test 2: FPSR clear
    // ==========================================

    msr fpsr, xzr
    mrs x1, fpsr             // Expect 0

    // ==========================================
    // Test 3: FPCR RMode = 11 (RTZ)
    // ==========================================

    bic x6, x4, #(3 << 22)
    orr x6, x6, #(3 << 22)   // Set RMode = 11 (RTZ)
    msr fpcr, x6
    mrs x2, fpcr
    and x2, x2, #(3 << 22)   // Expect 0x00C00000

    // ==========================================
    // Test 4: FPSR exception flags
    // ==========================================

    mov x6, #0x1F            // All exception flags
    msr fpsr, x6
    mrs x3, fpsr            // Expect 0x1F

    // Restore original values
    msr fpcr, x4
    msr fpsr, x5

    brk #0