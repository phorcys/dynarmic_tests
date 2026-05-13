/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x3FF8000000000000" }
}
*/
.text
.global _start
_start:
    // Double precision divide
    // D0 = D0 / D1
    // D0 = 6.0 / 4.0 = 1.5 = 0x3FF8000000000000
    vmov.f64 d0, #6.0
    vmov.f64 d1, #4.0
    vdiv.f64 d0, d0, d1
    bkpt #0
