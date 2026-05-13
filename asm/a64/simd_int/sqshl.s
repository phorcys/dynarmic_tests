/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000100000000000000010"
}
*/
// Test: SQSHL Vd.4S, Vn.4S, #amount - Signed Saturating Shift Left Immediate
// Shifts left with signed saturation

.text
.global _start
_start:
    mov w0, #2
    dup v0.4s, w0
    
    // SQSHL: signed saturating shift left
    // 2 << 3 = 16 (no saturation needed)
    sqshl v0.4s, v0.4s, #3
    
    brk #0
