/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4001E3779B97F4A8" }
}
*/
.text
.global _start
_start:
    @ VSQRT.F64: Vector Square Root (double precision)
    @ VSQRT.F64 Dd, Dm
    
    vmov.f64 d1, #5.0
    
    vsqrt.f64 d0, d1        @ D0 = sqrt(5.0) ≈ 2.236...
    
    bkpt #0