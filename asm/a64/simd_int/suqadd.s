/* CONFIG
{
  "Match": "All",
  "X0": "0x000000000000007F"
}
*/
// Test: SUQADD Vd, Vn - Signed Saturating Accumulating Add
// Adds unsigned value to signed value with saturation

.text
.global _start
_start:
    // Setup: signed 100, unsigned 50
    mov x0, #100
    mov x1, #50
    
    // SUQADD: signed accumulating add with unsigned
    suqadd v0.4h, v0.4h
    // Note: SUQADD is a NEON instruction, requires vector form
    
    brk #0
