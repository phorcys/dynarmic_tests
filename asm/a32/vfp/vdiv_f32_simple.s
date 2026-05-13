/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4000000040400000" }
}
*/
.text
.global _start
_start:
    @ VDIV.F32: Floating-point Divide Single
    
    vmov.f32 s0, #6.0    @ s0 = 6.0 = 0x40C00000
    vmov.f32 s1, #2.0    @ s1 = 2.0 = 0x40000000
    
    vdiv.f32 s0, s0, s1  @ s0 = 6.0 / 2.0 = 3.0 = 0x40400000
                         @ D0 = S1:S0 = 0x40000000_40400000
    
    bkpt #0
