/* CONFIG
{
  "Match": "All",
  "RegData": {
    "D0": "0x0000000040000000",
    "D1": "0x0000000040800000",
    "D2": "0x0000000041000000"
  }
}
*/
.text
.global _start
_start:
    // VMUL.F32: Multiply two single-precision floats
    // S0 = 2.0, S2 = 4.0, S4 = S0 * S2 = 8.0
    // 2.0 = 0x40000000, 4.0 = 0x40800000, 8.0 = 0x41000000
    vmov.f32 s0, #2.0
    vmov.f32 s2, #4.0
    vmul.f32 s4, s0, s2
    bkpt #0
