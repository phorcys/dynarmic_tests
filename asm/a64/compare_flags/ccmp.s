/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// Test: CCMP - Conditional Compare

.text
.global _start
_start:
    mov x0, #5
    mov x1, #5
    
    // Compare x0 and x1, set flags
    cmp x0, x1
    
    // If equal, compare x0 with #10
    ccmp x0, #10, #0, eq
    
    // If equal (x0 == 10?), set x0 = 1
    cset x0, eq

    brk #0
