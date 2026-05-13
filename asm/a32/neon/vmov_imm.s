/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x000000003F800000" }
}
*/
.text
.global _start
_start:
    @ VMOV immediate: Move floating point immediate
    @ VMOV.F32 Sd, #imm
    
    @ Move 1.0 to S0 (which is D0[0])
    vmov.f32 s0, #1.0    @ S0 = 1.0 = 0x3F800000
    @ D0 = {S1, S0} = {0, 0x3F800000}
    
    bkpt #0