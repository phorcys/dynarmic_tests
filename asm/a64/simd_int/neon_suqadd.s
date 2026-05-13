/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000002000000000000000100000000"
}
*/
// Test: SUQADD Vd.4S, Vn.4S - Signed Saturating Accumulate of Unsigned Value
// Accumulates unsigned values to signed values with saturation

.text
.global _start
_start:
    // Create vector with signed values: [1, 2, 3, 4]
    movi v0.4s, #1, lsl #0
    movi v1.4s, #1, lsl #0
    
    // Add unsigned values: v0 = v0 + v1 (signed accumulate unsigned)
    // Each element: 1 + 1 = 2
    suqadd v0.4s, v1.4s
    
    // V0 = [2, 2, 2, 2]

    brk #0
