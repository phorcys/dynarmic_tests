/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x3FF0000000000000",
    "X1": "0x4008000000000000"
  }
}
*/
.text
.global _start
_start:
    // FCADD - 浮点复数加法
    // FCADD Vd.2D, Vn.2D, Vm.2D, #rotate
    // rotate=90: Vd[0] = Vn[0] - Vm[1], Vd[1] = Vn[1] + Vm[0]
    
    // V1 = (1.0, 2.0)
    mov x8, #0x0000000000000000
    movk x8, #0x3FF0, lsl #48  // 1.0
    fmov d1, x8
    
    mov x9, #0x0000000000000000
    movk x9, #0x4000, lsl #48  // 2.0
    mov v1.d[1], x9
    
    // V2 = (1.0, 0.0)
    mov x10, #0x0000000000000000
    movk x10, #0x3FF0, lsl #48  // 1.0
    fmov d2, x10
    
    // FCADD with rotate=90: V0 = (1.0-0.0, 2.0+1.0) = (1.0, 3.0)
    fcadd v0.2d, v1.2d, v2.2d, #90
    
    fmov x0, d0
    mov x1, v0.d[1]

    brk #0