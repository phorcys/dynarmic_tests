/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4000000040800000" }
}
*/
.text
.global _start
_start:
    @ VMUL.F32: Floating-point Multiply Single
    
    vmov.f32 s0, #2.0    @ s0 = 2.0 = 0x40000000
    vmov.f32 s1, #2.0    @ s1 = 2.0 = 0x40000000
    
    vmul.f32 s0, s0, s1  @ s0 = 2.0 * 2.0 = 4.0 = 0x40800000
                         @ D0 = S1:S0 = 0x40000000_40800000
    
    bkpt #0
