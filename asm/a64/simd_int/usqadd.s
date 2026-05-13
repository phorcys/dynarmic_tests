/* CONFIG
{
  "Match": "All",
  "X0": "0x000000000000007F"
}
*/
// Test: USQADD Vd, Vn - Unsigned Saturating Accumulating Add
// Adds signed value to unsigned value with saturation

.text
.global _start
_start:
    // Setup: unsigned 100, signed 50
    mov x0, #100
    mov x1, #50
    
    // USQADD: unsigned accumulating add with signed
    usqadd v0.4h, v0.4h
    // Note: USQADD is a NEON instruction, requires vector form
    
    brk #0
