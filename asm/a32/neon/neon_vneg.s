/* CONFIG
{
  "Match": "All",
  "VecData": { 
    "Q0": ["0xFFFFFFE0FFFFFFE0", "0xFFFFFFE0FFFFFFE0"]
  }
}
*/
.text
.global _start
_start:
    // VNEG.S32: Q0 = -Q0
    vmov.i32 q0, #0x20
    vneg.s32 q0, q0   // -0x20 = 0xFFFFFFE0
    
    bkpt #0
