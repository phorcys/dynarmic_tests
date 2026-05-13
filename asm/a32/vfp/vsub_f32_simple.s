/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4080000040800000" }
}
*/
.text
.global _start
_start:
    @ VSUB.F32: Floating-point Subtract Single
    
    vmov.f32 s0, #8.0    @ s0 = 8.0 = 0x41000000
    vmov.f32 s1, #4.0    @ s1 = 4.0 = 0x40800000
    
    vsub.f32 s0, s0, s1  @ s0 = 8.0 - 4.0 = 4.0 = 0x40800000
                         @ D0 = S1:S0 = 0x40800000_40800000
    
    bkpt #0