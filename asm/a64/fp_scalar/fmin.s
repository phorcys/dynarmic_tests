/* CONFIG
{
  "Match": "All",
  "Q0": "0x40000000400000004000000040000000"
}
*/
// Test: FMIN Vd.4S, Vn.4S, Vm.4S - Floating-point Minimum (vector)
// Vd = min(Vn, Vm)

.text
.global _start
_start:
    fmov s0, #2.0
    dup v0.4s, v0.s[0]
    fmov s1, #3.0
    dup v1.4s, v1.s[0]
    
    // FMIN: v0 = min(2.0, 3.0) = 2.0 for each element
    fmin v0.4s, v0.4s, v1.4s
    
    brk #0
