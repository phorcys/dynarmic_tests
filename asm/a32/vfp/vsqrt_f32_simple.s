/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4080000040000000" }
}
*/
.text
.global _start
_start:
    @ VSQRT.F32: Floating-point Square Root
    
    vmov.f32 s0, #4.0    @ s0 = 4.0 = 0x40800000
    vmov.f32 s1, #4.0    @ s1 = 4.0 = 0x40800000
    
    vsqrt.f32 s0, s0     @ s0 = sqrt(4.0) = 2.0 = 0x40000000
                         @ D0 = S1:S0 = 0x40800000_40000000
    
    bkpt #0
