/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: RADDHN2 Vd.8H, Vn.4S, Vm.4S - Rounding Add Narrowing High
// Adds with rounding and stores high half of result

.text
.global _start
_start:
    mov w0, #0
    dup v0.4s, w0
    mov w0, #0
    dup v1.4s, w0
    
    // RADDHN2: rounding add and narrow high half
    // 0 + 0 = 0
    raddhn2 v0.8h, v1.4s, v1.4s
    
    brk #0
