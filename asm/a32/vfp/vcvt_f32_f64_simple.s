/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4010000040800000" }
}
*/
.text
.global _start
_start:
    @ VCVT: Convert between single and double precision
    @ VCVT.F32.F64 Sd, Dm
    
    vmov.f64 d0, #4.0       @ D0 = 4.0 (double) = 0x4010000000000000
    
    vcvt.f32.f64 s0, d0     @ S0 = 4.0 (single) = 0x40800000
                            @ D0 = S1:S0 = 0x40100000_40800000 (S1 is unchanged)
    
    bkpt #0
.ltorg