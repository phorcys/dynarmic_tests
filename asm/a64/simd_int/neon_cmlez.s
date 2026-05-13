/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
}
*/
// Test: CMLE Vd.2D, Vn.2D, #0 - Compare Less than or Equal to Zero
// If element <= 0, result is all 1s; otherwise all 0s

.text
.global _start
_start:
    // Create vector with zeros
    movi v0.2d, #0
    movi v1.2d, #0
    
    // Compare zeros <= 0 -> all 1s
    cmle v0.2d, v0.2d, #0
    
    // V0 should be all 1s (0xFFFF...)

    brk #0
