/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000000000000000000000"
  }
}
*/
// Test: SUBHN - Subtract and narrow

.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #1
    
    subhn v0.4h, v0.4s, v1.4s   // [1-1, 1-1, 1-1, 1-1] = [0, 0, 0, 0]
    
    brk #0
