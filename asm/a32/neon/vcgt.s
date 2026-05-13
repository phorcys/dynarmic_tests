/* CONFIG
{
  "Match": "All",
  "VecData": { 
    "Q0": ["0xFFFFFFFFFFFFFFFF", "0xFFFFFFFFFFFFFFFF"]
  }
}
*/
.text
.global _start
_start:
    // VCGT.S32: Q0 = (Q0 > Q1) ? ~0 : 0
    vmov.i32 q0, #0x20
    vmov.i32 q1, #0x10
    vcgt.s32 q0, q0, q1
    
    bkpt #0
