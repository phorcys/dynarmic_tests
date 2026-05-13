/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40800000400000004080000040000000",
    "Q1": "0x41000000404000004100000040400000",
    "Q2": "0x40800000400000004080000040000000"
  }
}
*/
// Test: FMIN Vd.4S, Vn.4S, Vm.4S - floating-point minimum (4x single)
// V0.4S = [2.0, 4.0, 2.0, 4.0]
// V1.4S = [3.0, 8.0, 3.0, 8.0]
// V2.4S = min(V0, V1) = [2.0, 4.0, 2.0, 4.0]

.text
.global _start
_start:
    // Load V0 with [2.0, 4.0, 2.0, 4.0]
    fmov s0, #2.0
    fmov s1, #4.0
    dup v0.4s, v0.s[0]
    ins v0.s[1], v1.s[0]
    ins v0.s[2], v0.s[0]
    ins v0.s[3], v1.s[0]

    // Load V1 with [3.0, 8.0, 3.0, 8.0]
    fmov s1, #3.0
    fmov s2, #8.0
    dup v1.4s, v1.s[0]
    ins v1.s[1], v2.s[0]
    ins v1.s[2], v1.s[0]
    ins v1.s[3], v2.s[0]

    // Vector minimum
    fmin v2.4s, v0.4s, v1.4s

    brk #0