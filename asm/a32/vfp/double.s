/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x4000000000000000", "D1": "0x3ff6a09e667f3bcd" }
}
*/
.text
.global _start
_start:
    // D0 = 2.0
    vmov.f64 d0, #2.0
    
    // D1 = sqrt(2.0) ≈ 1.414213562...
    vsqrt.f64 d1, d0
    
    bkpt #0
