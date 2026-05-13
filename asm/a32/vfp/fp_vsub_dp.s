/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x4000000000000000" }
}
*/
.text
.global _start
_start:
    // Double precision subtract
    // D0 = D0 - D1
    // D0 = 5.0 - 3.0 = 2.0 = 0x4000000000000000
    vmov.f64 d0, #5.0
    vmov.f64 d1, #3.0
    vsub.f64 d0, d0, d1
    bkpt #0
