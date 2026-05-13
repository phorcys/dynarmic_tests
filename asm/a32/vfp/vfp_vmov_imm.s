/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "D0": "0x0000000040000000",
    "D1": "0x0000000040400000",
    "D2": "0x0000000040c00000",
    "D3": "0x00000000c0000000"
  }
}
*/
.text
.global _start
_start:
    vmov.f32 s0, #2.0
    vmov.f32 s2, #3.0
    vmov.f32 s4, #6.0
    vmov.f32 s6, #-2.0
    
    bkpt #0
