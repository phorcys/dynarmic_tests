/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x4028000000000000", "D1": "0x4000000000000000", "D2": "0x4008000000000000" }
}
*/
.text
.global _start
_start:
    // VFMA.F64: Fused Multiply-Add Double Precision
    // D0 = D1 * D2 + D0
    // D1 = 2.0, D2 = 3.0, D0 = 6.0
    // D0 = 2.0 * 3.0 + 6.0 = 12.0 = 0x4028000000000000
    vmov.f64 d1, #2.0
    vmov.f64 d2, #3.0
    vmov.f64 d0, #6.0
    vfma.f64 d0, d1, d2
    bkpt #0
