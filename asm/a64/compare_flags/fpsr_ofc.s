/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000014" }
}
*/
// Test: FPSR OFC (Overflow) flag
// OFC is bit 2 of FPSR
// Note: Overflow also typically sets IXC (inexact)

.text
.global _start
_start:
    // Clear FPSR
    msr fpsr, xzr

    // Test: Overflow - use double precision for better control
    // DBL_MAX ≈ 1.7976931348623157e308 = 0x7FEFFFFFFFFFFFFF
    // Multiply by 2 should overflow
    mov x0, #0xFFFFFFFF
    movk x0, #0xFFFF, lsl #16
    movk x0, #0xFFFF, lsl #32
    movk x0, #0x7FEF, lsl #48    // x0 = 0x7FEFFFFFFFFFFFFF (close to DBL_MAX)
    fmov d0, x0
    fmov d1, #2.0
    fmul d2, d0, d1       // DBL_MAX * 2.0 = overflow

    // Read FPSR
    mrs x0, fpsr
    // Should have OFC (bit 2) and IXC (bit 4) set = 0x14

    brk #0
