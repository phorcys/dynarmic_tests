/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005",
    "X1": "0x0000000000000006"
  }
}
*/
// Test: CINC Xd, Xn, cond - conditional increment

.text
.global _start
_start:
    mov x0, #5
    
    cmp x0, #5            // Sets Z=1
    
    cinc x1, x0, eq       // If equal, x1 = x0 + 1, else x1 = x0

    brk #0
