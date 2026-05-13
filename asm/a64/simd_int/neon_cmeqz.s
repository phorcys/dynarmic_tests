/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
}
*/
// Test: CMEQ Vd.2D, Vn.2D, #0 - Compare Equal to Zero
// If element == 0, result is all 1s; otherwise all 0s

.text
.global _start
_start:
    // Create vector with zeros
    movi v0.2d, #0
    movi v1.2d, #0
    
    // Compare zeros with zero -> all 1s
    cmeq v0.2d, v0.2d, #0
    
    // V0 should be all 1s (0xFFFF...)

    brk #0
