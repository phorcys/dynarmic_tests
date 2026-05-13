/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000000000000000000000"
  }
}
*/
// Test: RSUBHN - Round subtract and narrow

.text
.global _start
_start:
    movi v0.4s, #2
    movi v1.4s, #1
    
    rsubhn v0.4h, v0.4s, v1.4s   // [2-1, 2-1, 2-1, 2-1] = [1, 1, 1, 1]
    
    brk #0
