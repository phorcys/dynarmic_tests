/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x0000000040000000", "D1": "0x0000000040400000", "D2": "0x00000000c0c00000" }
}
*/
.text
.global _start
_start:
    // S0 = 2.0, S2 = 3.0
    vmov.f32 s0, #2.0
    vmov.f32 s2, #3.0
    
    // S4 = -S0 * S2 = -2.0 * 3.0 = -6.0
    vnmul.f32 s4, s0, s2
    
    bkpt #0
