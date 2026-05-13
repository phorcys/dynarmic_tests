/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000100000000000000010"
}
*/
// Test: UQSHL Vd.4S, Vn.4S, #amount - Unsigned Saturating Shift Left Immediate
// Shifts left with unsigned saturation

.text
.global _start
_start:
    mov w0, #2
    dup v0.4s, w0
    
    // UQSHL: unsigned saturating shift left
    // 2 << 3 = 16 (no saturation needed)
    uqshl v0.4s, v0.4s, #3
    
    brk #0
