/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "D0": "0x0000000040c00000",
    "D1": "0x0000000040000000",
    "D2": "0x0000000040400000",
    "D3": "0x00000000c0c00000"
  }
}
*/
.text
.global _start
_start:
    @ S0 = 6.0, S2 = 2.0, S4 = 3.0
    vmov.f32 s0, #6.0
    vmov.f32 s2, #2.0
    vmov.f32 s4, #3.0
    
    @ VNMLA: Sd = -Sd - Sn * Sm
    @ S6 = -S6 - S2 * S4 = -0 - 2.0 * 3.0 = -6.0
    vnmla.f32 s6, s2, s4
    
    bkpt #0