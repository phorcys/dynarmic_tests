/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000030000000000000003",
    "Q1": "0x00000000000000010000000000000001",
    "Q2": "0x00000000000000020000000000000002"
  }
}
*/
// Test: SUB Vd.2D, Vn.2D, Vm.2D - subtract 64-bit integers

.text
.global _start
_start:
    // Load Q0 with [3, 3]
    mov x0, #3
    dup v0.2d, x0
    
    // Load Q1 with [1, 1]
    mov x1, #1
    dup v1.2d, x1
    
    // Q2 = Q0 - Q1 = [2, 2]
    sub v2.2d, v0.2d, v1.2d

    brk #0
