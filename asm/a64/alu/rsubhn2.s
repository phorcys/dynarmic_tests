/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: RSUBHN2 Vd.8H, Vn.4S, Vm.4S - Rounding Subtract Narrowing High
// Subtracts with rounding and stores high half of result

.text
.global _start
_start:
    mov w0, #0
    dup v0.4s, w0
    mov w0, #0
    dup v1.4s, w0
    
    // RSUBHN2: rounding subtract and narrow high half
    // 0 - 0 = 0
    rsubhn2 v0.8h, v1.4s, v1.4s
    
    brk #0
