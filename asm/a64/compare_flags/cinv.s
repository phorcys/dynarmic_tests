/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005",
    "X1": "0xFFFFFFFFFFFFFFFA"
  }
}
*/
// Test: CINV Xd, Xn, cond - conditional invert

.text
.global _start
_start:
    mov x0, #5
    
    cmp x0, #5            // Sets Z=1
    
    cinv x1, x0, eq       // If equal, x1 = ~x0, else x1 = x0

    brk #0
