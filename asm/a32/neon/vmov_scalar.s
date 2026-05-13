/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x3F800000", "R1": "0x40000000" }
}
*/
.text
.global _start
_start:
    @ VMOV between ARM register and scalar
    @ VMOV Rt, Sn
    
    vmov.f32 s0, #1.0    @ S0 = 1.0 = 0x3F800000
    vmov.f32 s1, #2.0    @ S1 = 2.0 = 0x40000000
    
    vmov r0, s0          @ R0 = bit pattern of 1.0 = 0x3F800000
    vmov r1, s1          @ R1 = bit pattern of 2.0 = 0x40000000
    
    bkpt #0