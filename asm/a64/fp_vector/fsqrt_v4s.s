/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40000000400000004000000040000000",
    "Q1": "0x3FB504F33FB504F33FB504F33FB504F3"
  }
}
*/
// Test: FSQRT Vd.4S, Vn.4S - floating-point square root (4x single)
// V0.4S = [2.0, 2.0, 2.0, 2.0]
// V1.4S = sqrt(V0) = [1.414..., 1.414..., 1.414..., 1.414...]

.text
.global _start
_start:
    // Load V0 with 2.0 in all 32-bit lanes
    fmov s0, #2.0
    dup v0.4s, v0.s[0]

    // Vector square root
    fsqrt v1.4s, v0.4s

    brk #0
