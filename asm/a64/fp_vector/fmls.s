/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000001"
}
*/
// Test: FMLS Vd.4S, Vn.4S, Vm.4S - Floating-point Multiply-Subtract
// Vd = Vd - Vn * Vm

.text
.global _start
_start:
    // v0.4s = [5.0, 5.0, 5.0, 5.0]
    fmov s0, #5.0
    dup v0.4s, v0.s[0]
    
    // v1.4s = [2.0, 2.0, 2.0, 2.0]
    fmov s1, #2.0
    dup v1.4s, v1.s[0]
    
    // v2.4s = [1.0, 1.0, 1.0, 1.0]
    fmov s2, #1.0
    dup v2.4s, v2.s[0]
    
    // FMLS: v0 = v0 - v1 * v2 = [5-2*1, 5-2*1, 5-2*1, 5-2*1] = [3.0, 3.0, 3.0, 3.0]
    fmls v0.4s, v1.4s, v2.4s
    
    brk #0
