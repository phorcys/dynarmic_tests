/* CONFIG
{
  "Match": "All",
  "RegData": {
    "D0": "0x00000000C0000000",
    "D1": "0x0000000040000000"
  }
}
*/
.text
.global _start
_start:
    // VABS.F32: Absolute value of single-precision float
    // S0 = -2.0, S2 = |S0| = 2.0
    // -2.0 = 0xC0000000, 2.0 = 0x40000000
    vmov.f32 s0, #-2.0
    vabs.f32 s2, s0
    bkpt #0
