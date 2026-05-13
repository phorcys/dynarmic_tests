/* CONFIG
{
  "Match": "All",
  "KnownFailure": "QEMU does not set UFC flag for underflow operations",
  "QemuSkip": "QEMU does not set UFC flag for underflow operations",
  "RegData": { "X0": "0x0000000000000018" }
}
*/
// Test: FPSR UFC (Underflow) flag
// UFC is bit 3 of FPSR
// Note: Underflow also typically sets IXC (inexact)

.text
.global _start
_start:
    // Clear FPSR
    msr fpsr, xzr

    // Test: Underflow - multiply smallest normalized by small factor
    // FLT_MIN (smallest normalized float) = 0x00800000 ≈ 1.18e-38
    // Multiply by 0.5 repeatedly to get underflow
    mov w0, #0x8000
    movk w0, #0x0080, lsl #16    // w0 = 0x00800000 (FLT_MIN)
    fmov s0, w0
    fmov s1, #0.5
    
    // Repeatedly multiply to get underflow
    fmul s0, s0, s1    // FLT_MIN * 0.5 = subnormal
    fmul s0, s0, s1    // * 0.5 again
    fmul s0, s0, s1    // * 0.5 again

    // Read FPSR
    mrs x0, fpsr
    // Should have UFC (bit 3) and IXC (bit 4) set = 0x18

    brk #0
