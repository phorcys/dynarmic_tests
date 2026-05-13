/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005",
    "X1": "0x0000000000000003",
    "X2": "0x0000000000000003"
  }
}
*/
// Test: CCMP Xn, Xm, #nzcv, cond - conditional compare register

.text
.global _start
_start:
    mov x0, #5
    mov x1, #3
    mov x2, #3
    
    // Compare x0 with 5, set flags
    cmp x0, #5
    
    // If equal, compare x1 with x2
    ccmp x1, x2, #0, eq

    brk #0
