/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000100000000000000010"
}
*/
// Test: SQRSHL Vd.4S, Vn.4S, Vm.4S - Signed Saturating Rounding Shift Left by Register
// Shifts left with signed saturation and rounding

.text
.global _start
_start:
    mov w0, #2
    dup v0.4s, w0
    mov w1, #3
    dup v1.4s, w1
    
    // SQRSHL: signed saturating rounding shift left by register
    // 2 << 3 = 16
    sqrshl v0.4s, v0.4s, v1.4s
    
    brk #0
