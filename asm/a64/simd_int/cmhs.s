/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFFFFFFFFFF0000000000000000"
}
*/
// Test: CMHS Vd.2D, Vn.2D, Vm.2D - Compare Higher or Same (unsigned)
// Sets destination element to all 1s if Vn >= Vm (unsigned), all 0s otherwise

.text
.global _start
_start:
    mov x0, #2
    dup v0.2d, x0
    mov x1, #1
    dup v1.2d, x1
    mov x2, #3
    dup v2.2d, x2
    
    // CMHS: compare higher or same (unsigned)
    // V0[0] >= V1[0] (2 >= 1) -> all 1s
    // V0[1] >= V2[0] (2 >= 3) -> all 0s
    cmhs v0.2d, v0.2d, v1.2d
    
    brk #0
