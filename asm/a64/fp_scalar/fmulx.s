/* CONFIG
{
  "Match": "All",
  "Q0": "0x40800000408000004080000040800000"
}
*/
// Test: FMULX Vd.4S, Vn.4S, Vm.4S - Floating-point Multiply Extended (vector)
// Vd = 2 * Vn * Vm

.text
.global _start
_start:
    fmov s0, #2.0
    dup v0.4s, v0.s[0]
    fmov s1, #3.0
    dup v1.4s, v1.s[0]
    
    // FMULX: v0 = 2 * v0 * v1 = 2 * 2.0 * 3.0 = 12.0 for each element
    fmulx v0.4s, v0.4s, v1.4s
    
    brk #0
