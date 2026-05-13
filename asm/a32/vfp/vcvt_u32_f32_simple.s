/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000000004" }
}
*/
.text
.global _start
_start:
    @ VCVT: Convert floating point to unsigned integer
    @ VCVT.U32.F32 Sd, Sm
    
    vmov.f32 s0, #4.0       @ S0 = 4.0
    
    vcvt.u32.f32 s0, s0     @ S0 = 4 (integer)
    
    bkpt #0
.ltorg
