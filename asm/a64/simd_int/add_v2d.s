/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000010000000000000001",
    "Q1": "0x00000000000000020000000000000002",
    "Q2": "0x00000000000000030000000000000003"
  }
}
*/
// Test: ADD Vd.2D, Vn.2D, Vm.2D - add 64-bit integers

.text
.global _start
_start:
    // Load Q0 with [1, 1]
    mov x0, #1
    dup v0.2d, x0
    
    // Load Q1 with [2, 2]
    mov x1, #2
    dup v1.2d, x1
    
    // Q2 = Q0 + Q1 = [3, 3]
    add v2.2d, v0.2d, v1.2d

    brk #0
