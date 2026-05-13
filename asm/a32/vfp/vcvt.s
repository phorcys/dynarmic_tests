/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "D0": "0x0000000041c80000",
    "D2": "0x0000000000000019"
  }
}
*/
.text
.global _start
_start:
    // Float to int conversion - only use immediates that are encodable
    vmov.f32 s0, #25.0
    vcvt.s32.f32 s4, s0   // S4 = (int)25.0 = 25
    
    bkpt #0