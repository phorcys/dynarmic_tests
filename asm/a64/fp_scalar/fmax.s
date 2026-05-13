/* CONFIG
{
  "Match": "All",
  "Q0": "0x40200000402000004020000040200000"
}
*/
// Test: FMAX Vd.4S, Vn.4S, Vm.4S - Floating-point Maximum (vector)
// Vd = max(Vn, Vm)

.text
.global _start
_start:
    fmov s0, #2.0
    dup v0.4s, v0.s[0]
    fmov s1, #3.0
    dup v1.4s, v1.s[0]
    
    // FMAX: v0 = max(2.0, 3.0) = 3.0 for each element
    fmax v0.4s, v0.4s, v1.4s
    
    brk #0
