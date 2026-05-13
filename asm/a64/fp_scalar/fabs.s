/* CONFIG
{
  "Match": "All",
  "Q0": "0x40000000400000004000000040000000"
}
*/
// Test: FABS Vd.4S, Vn.4S - Floating-point Absolute Value (vector)
// Vd = |Vn|

.text
.global _start
_start:
    fmov s0, #-2.0
    dup v0.4s, v0.s[0]
    
    // FABS: v0 = |-2.0| = 2.0 for each element
    fabs v0.4s, v0.4s
    
    brk #0
