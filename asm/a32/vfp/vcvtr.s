/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "D0": "0x0000000040400000",
    "D1": "0x0000000000000003"
  }
}
*/
.text
.global _start
_start:
    // S0 = 3.0
    vmov.f32 s0, #3.0
    
    // Round to nearest integer
    vcvtr.s32.f32 s2, s0   // S2 = round(3.0) = 3
    
    bkpt #0
