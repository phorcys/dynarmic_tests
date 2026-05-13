/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFF000000000000000000000000"
}
*/
// Test: RAX1 Vd.2D, Vn.2D, Vm.2D - Rotate and exclusive OR
// Vd = Vn XOR (Vm rotated left by 1)

.text
.global _start
_start:
    // v0 = [0, 0] - result
    movi v0.2d, #0
    
    // v1 = [0xFFFFFFFFFFFFFFFF, 0]
    mov x0, #-1
    mov v1.d[0], x0
    mov x0, #0
    mov v1.d[1], x0
    
    // v2 = [0, 0] - rotation value
    movi v2.2d, #0
    
    // RAX1: v0 = v1 XOR (v2 rotated left by 1)
    // v2 rotated left by 1 = [0, 0]
    // v0 = v1 XOR 0 = v1 = [0xFFFFFFFFFFFFFFFF, 0]
    rax1 v0.2d, v1.2d, v2.2d
    
    brk #0
