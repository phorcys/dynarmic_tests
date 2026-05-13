/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000000004" }
}
*/
.text
.global _start
_start:
    @ VCVTR: Convert floating point to signed integer with rounding
    @ VCVTR.S32.F32 Sd, Sm
    
    @ Use integer to create float value
    mov r0, #4
    vmov s0, r0
    
    vcvt.f32.s32 s0, s0     @ S0 = 4.0
    
    vcvtr.s32.f32 s0, s0    @ S0 = 4 (rounded from 4.0)
    
    bkpt #0
.ltorg