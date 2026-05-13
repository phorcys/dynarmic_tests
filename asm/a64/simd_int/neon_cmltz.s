/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: CMLT Vd.2D, Vn.2D, #0 - Compare Less than Zero
// If element < 0, result is all 1s; otherwise all 0s

.text
.global _start
_start:
    // Create vector with zeros
    movi v0.2d, #0
    movi v1.2d, #0
    
    // Compare zeros < 0 -> all 0s
    cmlt v0.2d, v0.2d, #0
    
    // V0 should be all 0s

    brk #0
