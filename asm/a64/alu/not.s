/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
}
*/
// Test: NOT Vd, Vn - Bitwise NOT
// Computes bitwise NOT of a vector

.text
.global _start
_start:
    // Setup: all zeros
    movi v0.16b, #0
    
    // NOT: bitwise NOT
    not v0.16b, v0.16b
    
    brk #0
