/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000002000000000000000100000000"
}
*/
// Test: USQADD Vd.4S, Vn.4S - Unsigned Saturating Accumulate of Signed Value
// Accumulates signed values to unsigned values with saturation

.text
.global _start
_start:
    // Create vector with unsigned values: [1, 1, 1, 1]
    movi v0.4s, #1, lsl #0
    movi v1.4s, #1, lsl #0
    
    // Add signed values: v0 = v0 + v1 (unsigned accumulate signed)
    // Each element: 1 + 1 = 2
    usqadd v0.4s, v1.4s
    
    // V0 = [2, 2, 2, 2]

    brk #0
