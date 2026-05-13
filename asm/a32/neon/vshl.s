/* CONFIG
{
  "Match": "All",
  "VecData": { 
    "Q0": ["0x0000008000000080", "0x0000008000000080"]
  }
}
*/
.text
.global _start
_start:
    // VSHL.I32: Q0 = Q0 << 4
    vmov.i32 q0, #0x08
    vshl.i32 q0, q0, #4   // 0x08 << 4 = 0x80
    
    bkpt #0
