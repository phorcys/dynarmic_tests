/* CONFIG
{
  "Match": "All",
  "Q0": "0x40000000400000004000000040000000"
}
*/
// Test: FMUL Vd.4S, Vn.4S, Vm.4S - Floating-point Multiply (vector)
// Vd = Vn * Vm

.text
.global _start
_start:
    fmov s0, #2.0
    dup v0.4s, v0.s[0]
    fmov s1, #3.0
    dup v1.4s, v1.s[0]
    
    // FMUL: v0 = v0 * v1 = 2.0 * 3.0 = 6.0 for each element
    fmul v0.4s, v0.4s, v1.4s
    
    brk #0
