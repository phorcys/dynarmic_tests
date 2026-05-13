/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000002" }
}
*/
// Test: FPSR DZC (Divide by Zero) flag
// DZC is bit 1 of FPSR

.text
.global _start
_start:
    // Clear FPSR
    msr fpsr, xzr

    // Test: Divide by zero
    // 1.0 / 0.0 should set DZC (Divide by Zero)
    fmov s0, #1.0
    movi v1.2s, #0        // s1 = 0.0
    fdiv s2, s0, s1       // 1.0 / 0.0 = inf, sets DZC

    // Read FPSR
    mrs x0, fpsr
    // Should have DZC (bit 1) set = 0x02

    brk #0
