/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x41800000"
  }
}
*/
.text
.arm
.global _start
_start:
    @ VMUL.F32 S0, S1, S2
    @ S1 = 4.0 (0x40800000), S2 = 4.0 (0x40800000)
    @ S0 = 4.0 * 4.0 = 16.0 (0x41800000)
    
    @ Load 4.0 into S1
    movw r0, #0x0000
    movt r0, #0x4080
    vmov s1, r0
    
    @ Load 4.0 into S2
    vmov s2, r0
    
    vmul.f32 s0, s1, s2
    
    vmov r0, s0
    bkpt #0
