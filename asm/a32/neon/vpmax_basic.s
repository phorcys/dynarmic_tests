/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x0005000500010001" }
}
*/
.text
.global _start
_start:
    @ VPMAX: Pairwise Maximum
    @ VPMAX.<type> Vd, Vn, Vm
    @ Max of adjacent pairs
    
    mov r0, #1
    vdup.16 d0, r0       @ D0 = [1, 1, 1, 1]
    
    mov r0, #5
    vdup.16 d1, r0       @ D1 = [5, 5, 5, 5]
    
    vpmax.u16 d0, d0, d1 @ D0 = [max(1,1), max(1,1), max(5,5), max(5,5)]
                         @    = [1, 1, 5, 5]
    
    bkpt #0