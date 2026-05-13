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
    // VEOR: Q0 = Q0 XOR Q1
    vmov.i32 q0, #0xFFFF0000
    vmov.i32 q1, #0x0000FFFF
    veor q0, q0, q1
    
    bkpt #0
