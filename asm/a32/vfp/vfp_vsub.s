/* CONFIG
{
  "Match": "All",
  "RegData": {
    "D0": "0x0000000040800000",
    "D1": "0x0000000040000000",
    "D2": "0x0000000040000000"
  }
}
*/
.text
.global _start
_start:
    // VSUB.F32: Subtract two single-precision floats
    // S0 = 4.0, S2 = 2.0, S4 = S0 - S2 = 2.0
    // 4.0 = 0x40800000, 2.0 = 0x40000000
    vmov.f32 s0, #4.0
    vmov.f32 s2, #2.0
    vsub.f32 s4, s0, s2
    bkpt #0
