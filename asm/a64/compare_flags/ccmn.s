/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// Test: CCMN - Conditional Compare Negative

.text
.global _start
_start:
    mov x0, #5
    mov x1, #5
    
    // Compare x0 and x1, set flags
    cmp x0, x1
    
    // If equal, compare x0 with -(-10) = 10
    ccmn x0, #10, #0, eq
    
    // If x0 != 10, set x0 = 0 (not equal)
    cset x0, ne

    brk #0
