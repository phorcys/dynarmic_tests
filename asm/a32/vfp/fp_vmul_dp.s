/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x4018000000000000", "D1": "0x4000000000000000" }
}
*/
.text
.global _start
_start:
    // Double precision multiply
    // D0 = D0 * D1
    // D0 = 3.0 * 2.0 = 6.0 = 0x4018000000000000
    vmov.f64 d1, #2.0
    vmov.f64 d0, #3.0
    vmul.f64 d0, d0, d1
    bkpt #0
