/* CONFIG
{
  "Match": "All",
  "Q0": "0x40000000400000004000000040000000"
}
*/
// Test: FMLA Vd.4S, Vn.4S, Vm.4S - Floating-point Multiply-Add (vector)
// Vd = Vd + Vn * Vm

.text
.global _start
_start:
    fmov s0, #2.0
    dup v0.4s, v0.s[0]
    fmov s1, #1.0
    dup v1.4s, v1.s[0]
    fmov s2, #1.0
    dup v2.4s, v2.s[0]
    
    // FMLA: v0 = v0 + v1 * v2 = 2.0 + 1.0 * 1.0 = 3.0 for each element
    fmla v0.4s, v1.4s, v2.4s
    
    brk #0
