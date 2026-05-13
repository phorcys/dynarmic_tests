/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000020000000000000002"
}
*/
// Test: SRSHL Vd.4S, Vn.4S, Vm.4S - Signed Rounding Shift Left
// Shifts left with rounding

.text
.global _start
_start:
    mov w0, #8
    dup v0.4s, w0
    mov w1, #1
    dup v1.4s, w1
    
    // SRSHL: signed rounding shift left by register value
    // 8 << 1 = 16
    srshl v0.4s, v0.4s, v1.4s
    
    brk #0
