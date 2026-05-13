/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000000000000000000000"
  }
}
*/
// Test: RADDHN - Round add and narrow

.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #1
    
    raddhn v0.4h, v0.4s, v1.4s   // [1+1, 1+1, 1+1, 1+1] = [2, 2, 2, 2]
    
    brk #0
