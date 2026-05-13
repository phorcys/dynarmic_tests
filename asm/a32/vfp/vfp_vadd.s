/* CONFIG
{
  "Match": "All",
  "RegData": {
    "D0": "0x0000000040000000",
    "D1": "0x0000000040800000",
    "D2": "0x0000000040C00000"
  }
}
*/
.text
.global _start
_start:
    // VADD.F32: Add two single-precision floats
    // S0 = 2.0 (D0 low), S2 = 4.0 (D1 low), S4 = S0 + S2 = 6.0 (D2 low)
    // 2.0 = 0x40000000, 4.0 = 0x40800000, 6.0 = 0x40C00000
    vmov.f32 s0, #2.0
    vmov.f32 s2, #4.0
    vadd.f32 s4, s0, s2
    bkpt #0
