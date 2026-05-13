/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "D0": "0x0000000040c00000",
    "D1": "0x0000000040000000",
    "D2": "0x0000000040400000",
    "D3": "0x0000000040c00000"
  }
}
*/
.text
.global _start
_start:
    @ S0 = 6.0 (D0 low), S2 = 2.0 (D1 low), S4 = 3.0 (D2 low)
    vmov.f32 s0, #6.0
    vmov.f32 s2, #2.0
    vmov.f32 s4, #3.0
    
    @ S6 = S6 + S2 * S4 = 0 + 2.0 * 3.0 = 6.0 (D3 low)
    @ Note: S6 is not initialized, so it starts at 0
    vmla.f32 s6, s2, s4
    
    bkpt #0