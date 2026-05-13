/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4010000000000000" }
}
*/
.text
.global _start
_start:
    @ VCVT: Convert between single and double precision
    @ VCVT.F64.F32 Dd, Sm
    
    vmov.f32 s0, #4.0       @ S0 = 4.0 (single)
    
    vcvt.f64.f32 d0, s0     @ D0 = 4.0 (double) = 0x4010000000000000
    
    bkpt #0
.ltorg
