/* CONFIG
{
  "Match": "All",
  "RegData": { "S0": "0x40200000", "S1": "0x40000000", "S2": "0x40000000", "S3": "0x40400000" }
}
*/
.text
.global _start
_start:
    // Test different rounding modes
    // Value to test: 2.5 = 0x40200000

    ldr w0, =0x40200000
    fmov s0, w0          // s0 = 2.5

    // Save original FPCR
    mrs x5, fpcr

    // === Test RNE (Round to Nearest Even) ===
    // 2.5 -> 2.0 (even)
    frintn s1, s0        // s1 = 2.0 = 0x40000000

    // === Test RTZ (Round Toward Zero) ===
    // 2.5 -> 2.0 (truncated toward zero)
    frintz s2, s0        // s2 = 2.0 = 0x40000000

    // === Test RUP (Round Up toward +inf) ===
    // 2.5 -> 3.0 (toward positive infinity)
    frintp s3, s0        // s3 = 3.0 = 0x40400000

    // Restore FPCR
    msr fpcr, x5

    brk #0
