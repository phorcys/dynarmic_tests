/* CONFIG
{
  "Match": "All",
  "RegData": { "S0": "0x7fc00000", "S1": "0x7f800000", "S2": "0x00000000", "S3": "0x007fffff" }
}
*/
.text
.global _start
_start:
    // Test floating-point special values

    // === NaN (Not a Number) ===
    ldr w0, =0x7fc00000      // Quiet NaN
    fmov s0, w0
    fmov s1, #1.0
    fadd s2, s0, s1          // s2 = NaN

    // === Infinity ===
    ldr w0, =0x7f800000      // +Inf
    fmov s3, w0
    fadd s4, s3, s3          // s4 = Inf

    // === Zero ===
    ldr w0, =0x00000000      // +0.0
    fmov s5, w0

    ldr w0, =0x80000000      // -0.0
    fmov s6, w0

    // === Denormal numbers ===
    ldr w0, =0x007fffff      // Largest denormal
    fmov s7, w0

    // Store results
    fmov s0, s2              // NaN result
    fmov s1, s4              // Inf result
    fmov s2, s5              // +0.0
    fmov s3, s7              // Denormal

    brk #0