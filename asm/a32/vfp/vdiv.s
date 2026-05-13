/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x40A00000"
  }
}
*/
.text
.arm
.global _start
_start:
    @ VDIV.F32 S0, S1, S2
    @ S1 = 10.0 (0x41200000), S2 = 2.0 (0x40000000)
    @ S0 = 10.0 / 2.0 = 5.0 (0x40A00000)
    
    @ Load 10.0 into S1
    movw r0, #0x0000
    movt r0, #0x4120
    vmov s1, r0
    
    @ Load 2.0 into S2
    movw r0, #0x0000
    movt r0, #0x4000
    vmov s2, r0
    
    vdiv.f32 s0, s1, s2
    
    vmov r0, s0
    bkpt #0
