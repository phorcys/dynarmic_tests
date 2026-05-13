/* CONFIG
{
  "Match": "All",
  "VecData": { 
    "Q0": ["0x0000002000000020", "0x0000002000000020"]
  }
}
*/
.text
.global _start
_start:
    // VABS.S32: Q0 = abs(Q0)
    vmvn.i32 q0, #0x1F   // q0 = ~0x1F = 0xFFFFFFE0 = -32
    vabs.s32 q0, q0      // abs(-32) = 32 = 0x20
    
    bkpt #0
