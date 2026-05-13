/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
.text
.global _start
_start:
    // BCAX - 位清除并异或
    // BCAX Vd.16B, Vn.16B, Vm.16B, Va.16B
    // Vd = (Vn AND NOT Vm) XOR Va
    // 测试：V0=0xFF, V1=0x00, V2=0x00
    // V0 AND NOT V1 = FF AND FF = FF
    // FF XOR 00 = FF
    
    // V0 = 0xFFFFFFFFFFFFFFFF
    mov x8, #-1
    fmov d0, x8
    
    // V1 = 0x0000000000000000
    fmov d1, xzr
    
    // V2 = 0x0000000000000000
    fmov d2, xzr
    
    bcax v3.16b, v0.16b, v1.16b, v2.16b
    
    fmov x0, d3

    brk #0
