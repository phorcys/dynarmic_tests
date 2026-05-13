/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4000000040A00000" }
}
*/
.text
.global _start
_start:
    @ VFMA.F32: Fused Multiply Add
    
    vmov.f32 s0, #1.0    @ s0 = 1.0 = 0x3F800000
    vmov.f32 s1, #2.0    @ s1 = 2.0 = 0x40000000
    vmov.f32 s2, #2.0    @ s2 = 2.0
    
    vfma.f32 s0, s1, s2  @ s0 = 1.0 + 2.0 * 2.0 = 5.0 = 0x40A00000
                         @ D0 = S1:S0 = 0x40000000_40A00000
    
    bkpt #0
