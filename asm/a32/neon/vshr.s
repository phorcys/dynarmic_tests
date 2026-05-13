/* CONFIG
{
  "Match": "All",
  "VecData": { 
    "Q0": ["0x0000000800000008", "0x0000000800000008"]
  }
}
*/
.text
.global _start
_start:
    // VSHR.U32: Q0 = Q0 >> 4
    vmov.i32 q0, #0x80
    vshr.u32 q0, q0, #4   // 0x80 >> 4 = 0x08
    
    bkpt #0
