/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x2000200020002000" }
}
*/
.text
.global _start
_start:
    @ VQDMULH: Vector Saturating Doubling Multiply High
    @ VQDMULH.<type> Vd, Vn, Vm
    @ Vd = saturate((2 * Vn * Vm) >> (element_bits))
    
    @ With larger values
    ldr r0, =0x4000      @ 16384
    vdup.16 d0, r0       @ D0 = [16384, 16384, 16384, 16384]
    
    ldr r0, =0x4000      @ 16384
    vdup.16 d1, r0       @ D1 = [16384, 16384, 16384, 16384]
    
    vqdmulh.s16 d0, d0, d1 @ D0 = (2 * 16384 * 16384) >> 16 
                           @ = 536870912 >> 16 = 8192 = 0x2000
    
    bkpt #0
.ltorg