/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x41300000"
  }
}
*/
.text
.arm
.global _start
_start:
    @ VADD.F32 S0, S1, S2
    @ S1 = 5.0 (0x40A00000), S2 = 6.0 (0x40C00000)
    @ S0 = 5.0 + 6.0 = 11.0 (0x41300000)
    
    @ Load 5.0 into S1
    movw r0, #0x0000
    movt r0, #0x40A0
    vmov s1, r0
    
    @ Load 6.0 into S2
    movw r0, #0x0000
    movt r0, #0x40C0
    vmov s2, r0
    
    vadd.f32 s0, s1, s2
    
    @ Move result back to r0 for verification
    vmov r0, s0
    bkpt #0
