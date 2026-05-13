/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
.text
.global _start
_start:
    // EOR3 - 三操作数异或
    // Vd = Vn XOR Vm XOR Va
    // EOR3 Vd.16B, Vn.16B, Vm.16B, Va.16B
    
    // V0 = 0xFFFFFFFFFFFFFFFF (bits 63:0)
    mov x8, #-1
    fmov d0, x8
    
    // V1 = 0xAAAAAAAAAAAAAAAA (bits 63:0)
    mov x9, #0xAAAAAAAAAAAAAAAA
    fmov d1, x9
    
    // V2 = 0x5555555555555555 (bits 63:0)
    mov x10, #0x5555555555555555
    fmov d2, x10
    
    eor3 v3.16b, v0.16b, v1.16b, v2.16b
    
    // FFFFFFFF XOR AAAAAAAA = 55555555
    // 55555555 XOR 55555555 = 00000000
    
    fmov x0, d3

    brk #0
