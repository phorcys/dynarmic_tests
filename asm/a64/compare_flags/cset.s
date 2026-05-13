/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005",
    "X1": "0x0000000000000001"
  }
}
*/
// Test: CSET Xd, cond - conditional set

.text
.global _start
_start:
    mov x0, #5
    
    cmp x0, #5            // Compare x0 with 5, sets Z=1
    
    cset x1, eq           // If equal, x1 = 1, else x1 = 0

    brk #0
