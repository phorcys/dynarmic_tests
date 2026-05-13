/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// Test: UQSUB - Saturating Subtract (unsigned, 4S)

.text
.global _start
_start:
    // V0 = {0x00000000, 0x00000000}
    fmov d0, xzr
    
    // V1 = {0x00000001, 0x00000001}
    movz x9, #0x0001
    fmov d1, x9
    
    // UQSUB: 0 - 1 = saturates to 0x00000000 (unsigned, cannot go negative)
    uqsub v0.4s, v0.4s, v1.4s
    
    fmov x0, d0

    brk #0
