/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000100000000000000010"
}
*/
// Test: URSHL Vd.4S, Vn.4S, Vm.4S - Unsigned Rounding Shift Left
// Shifts left with rounding

.text
.global _start
_start:
    mov w0, #8
    dup v0.4s, w0
    mov w1, #1
    dup v1.4s, w1
    
    // URSHL: unsigned rounding shift left by register value
    // 8 << 1 = 16
    urshl v0.4s, v0.4s, v1.4s
    
    brk #0
