/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4014000000000000" }
}
*/
.text
.global _start
_start:
    @ VCVT: Convert unsigned integer to double
    @ VCVT.F64.U32 Dd, Sm
    
    mov r0, #5
    vmov s0, r0             @ S0 = 5 (integer)
    
    vcvt.f64.u32 d0, s0     @ D0 = 5.0 = 0x4014000000000000
    
    bkpt #0
.ltorg
