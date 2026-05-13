/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40000000000000004000000000000000",
    "Q1": "0x3FF00000000000003FF0000000000000",
    "Q2": "0x3FF00000000000003FF0000000000000"
  }
}
*/
// Test: FSUB Vd.2D, Vn.2D, Vm.2D - subtract double precision

.text
.global _start
_start:
    // Load Q0 with 2.0, 2.0
    fmov d0, #2.0
    dup v0.2d, v0.d[0]
    
    // Load Q1 with 1.0, 1.0
    fmov d1, #1.0
    dup v1.2d, v1.d[0]
    
    // Q2 = Q0 - Q1 = [1.0, 1.0]
    fsub v2.2d, v0.2d, v1.2d

    brk #0
