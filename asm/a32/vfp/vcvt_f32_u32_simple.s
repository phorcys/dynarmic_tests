/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000040800000" }
}
*/
.text
.global _start
_start:
    @ VCVT: Convert between floating point and integer
    @ VCVT.F32.U32 Sd, Sm
    
    mov r0, #4
    vmov s0, r0             @ S0 = 4 (integer)
    
    vcvt.f32.u32 s0, s0     @ S0 = 4.0 = 0x40800000
    
    bkpt #0
.ltorg