/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFFFFFFFFFF0000000000000000"
}
*/
// Test: CMEQ Vd.2D, Vn.2D, Vm.2D - Compare Equal (vector)
// Sets destination element to all 1s if equal, all 0s otherwise

.text
.global _start
_start:
    mov x0, #1
    dup v0.2d, x0
    dup v1.2d, x0
    mov x1, #2
    dup v2.2d, x1
    
    // CMEQ: compare equal
    // V0[0] == V1[0] -> all 1s
    // V0[1] == V2[0] -> all 0s
    cmeq v0.2d, v0.2d, v1.2d
    
    brk #0
