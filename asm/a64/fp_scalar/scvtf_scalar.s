/* CONFIG
{
  "Match": "All",
  "D0": "0x4000000000000000"
}
*/
// Test: SCVTF Dd, Xn - Signed Integer Convert to Floating-point
// Converts signed integer to double

.text
.global _start
_start:
    mov x0, #2
    
    // SCVTF: signed integer convert to floating-point
    // 2 -> 2.0
    scvtf d0, x0
    
    brk #0
