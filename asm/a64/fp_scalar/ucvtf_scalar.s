/* CONFIG
{
  "Match": "All",
  "D0": "0x4000000000000000"
}
*/
// Test: UCVTF Dd, Xn - Unsigned Integer Convert to Floating-point
// Converts unsigned integer to double

.text
.global _start
_start:
    mov x0, #2
    
    // UCVTF: unsigned integer convert to floating-point
    // 2 -> 2.0
    ucvtf d0, x0
    
    brk #0
