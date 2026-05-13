/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000001" }
}
*/
// Test: FPSR IOC (Invalid Operation) flag
// IOC is bit 0 of FPSR

.text
.global _start
_start:
    // Clear FPSR
    msr fpsr, xzr

    // Test: Invalid operation - sqrt of negative number
    // -1.0 in float = 0xBF800000
    mov w0, #0
    movk w0, #0xBF80, lsl #16    // w0 = 0xBF800000 (-1.0)
    fmov s0, w0
    fsqrt s1, s0         // sqrt(-1.0) = NaN, sets IOC

    // Read FPSR
    mrs x0, fpsr
    // Should have IOC (bit 0) set = 0x01

    brk #0
