/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40100000000000004010000000000000",
    "Q1": "0x40000000000000004000000000000000",
    "Q2": "0x40000000000000004000000000000000"
  }
}
*/
// Test: FDIV Vd.2D, Vn.2D, Vm.2D - divide double precision

.text
.global _start
_start:
    // Load Q0 with 4.0, 4.0
    fmov d0, #4.0
    dup v0.2d, v0.d[0]
    
    // Load Q1 with 2.0, 2.0
    fmov d1, #2.0
    dup v1.2d, v1.d[0]
    
    // Q2 = Q0 / Q1 = [2.0, 2.0]
    fdiv v2.2d, v0.2d, v1.2d

    brk #0
