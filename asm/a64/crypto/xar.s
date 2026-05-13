/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000002000000000000000000000000"
}
*/
// Test: XAR Vd.2D, Vn.2D, Vm.2D, #imm - Exclusive OR and Rotate
// Vd = (Vn XOR Vm) rotated right by imm

.text
.global _start
_start:
    // v0 = [0, 0] - result
    movi v0.2d, #0
    
    // v1 = [1, 0]
    mov x0, #1
    mov v1.d[0], x0
    mov x0, #0
    mov v1.d[1], x0
    
    // v2 = [1, 0]
    mov x0, #1
    mov v2.d[0], x0
    mov x0, #0
    mov v2.d[1], x0
    
    // XAR with rotate amount 0: v0 = (v1 XOR v2) >> 0
    // v1 XOR v2 = [0, 0]
    // v0 = [0, 0]
    xar v0.2d, v1.2d, v2.2d, #0
    
    // Test with non-zero XOR
    movi v0.2d, #0
    mov x0, #3
    mov v1.d[0], x0
    mov x0, #1
    mov v2.d[0], x0
    
    // v1 XOR v2 = 3 XOR 1 = 2
    // rotated right by 0 = 2
    xar v0.2d, v1.2d, v2.2d, #0
    // v0.d[0] = 2
    
    brk #0
