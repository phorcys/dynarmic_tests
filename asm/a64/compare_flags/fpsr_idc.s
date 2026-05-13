/* CONFIG
{
  "Match": "All",
  "KnownFailure": "QEMU does not set IDC flag for denormal input operations",
  "QemuSkip": "QEMU does not set IDC flag for denormal input operations",
  "RegData": { "X0": "0x0000000000000080" }
}
*/
// Test: FPSR IDC (Input Denormal) flag
// IDC is bit 7 of FPSR

.text
.global _start
_start:
    // Clear FPSR
    msr fpsr, xzr

    // Test: Input Denormal - use a denormal number
    // Smallest positive denormal float = 0x00000001 ≈ 1.4e-45
    mov w0, #1            // w0 = 0x00000001 (denormal)
    fmov s0, w0           // s0 = denormal value
    
    // Perform operation that processes denormal
    fadd s1, s0, s0       // denormal + denormal should set IDC

    // Read FPSR
    mrs x0, fpsr
    // Should have IDC (bit 7) set = 0x80

    brk #0
