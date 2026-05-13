/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x0000000000000000" }
}
*/
.text
.global _start
_start:
    @ VQRDMULH: Vector Saturating Rounding Doubling Multiply High
    @ VQRDMULH.<type> Vd, Vn, Vm
    
    @ With -1 * -1 = 1, then 2*1 = 2, then >> 16 = 0
    mvn r0, #0           @ r0 = -1
    vdup.16 d0, r0       @ D0 = [-1, -1, -1, -1]
    
    mvn r0, #0
    vdup.16 d1, r0       @ D1 = [-1, -1, -1, -1]
    
    vqrdmulh.s16 d0, d0, d1 @ D0 = round((2 * -1 * -1) >> 16) = round(2 >> 16) = 0
    
    bkpt #0