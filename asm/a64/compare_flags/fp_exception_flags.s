/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000010" }
}
*/
.text
.global _start
_start:
    // Test FP exception flags in FPSR
    // IOC (bit 0) - Invalid Operation
    // DZC (bit 1) - Divide by Zero
    // OFC (bit 2) - Overflow
    // UFC (bit 3) - Underflow
    // IXC (bit 4) - Inexact
    // IDC (bit 7) - Input Denormal

    // Clear FPSR
    msr fpsr, xzr

    // Test 1: Inexact exception (IXC)
    // 1.0 / 3.0 = 0.333... (inexact)
    fmov s0, #1.0
    fmov s1, #3.0
    fdiv s2, s0, s1      // This should set IXC

    // Read FPSR
    mrs x0, fpsr
    // Should have IXC (bit 4) set = 0x10

    brk #0