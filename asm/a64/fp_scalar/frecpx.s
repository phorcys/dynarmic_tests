/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000003F800000"
  }
}
*/
// Test: FRECPX - Reciprocal exponent (scalar)
// FRECPX S0, S0: For 2.0 (0x40000000), result is 0x3F800000 (1.0 in float)

.text
.global _start
_start:
    // Load 2.0 into S0
    movz x8, #0x0000, lsl #0
    movk x8, #0x4000, lsl #16
    fmov s0, w8
    frecpx s0, s0
    
    // Move result to W0 (32-bit) then zero-extend to X0
    fmov w0, s0

    brk #0
