/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4080000041000000" }
}
*/
.text
.global _start
_start:
    @ VADD.F32: Floating-point Add Single
    
    vmov.f32 s0, #4.0    @ s0 = 4.0 = 0x40800000
    vmov.f32 s1, #4.0    @ s1 = 4.0 = 0x40800000
    
    vadd.f32 s0, s0, s1  @ s0 = 4.0 + 4.0 = 8.0 = 0x41000000
                         @ D0 = S1:S0 = 0x40800000_41000000
    
    bkpt #0