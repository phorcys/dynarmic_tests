/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x000A000A00060006" }
}
*/
.text
.global _start
_start:
    @ VPADD: Pairwise Add
    @ VPADD.<size> Vd, Vn, Vm
    @ Add adjacent pairs
    
    mov r0, #3
    vdup.16 d0, r0       @ D0 = [3, 3, 3, 3]
    
    mov r0, #5
    vdup.16 d1, r0       @ D1 = [5, 5, 5, 5]
    
    vpadd.i16 d0, d0, d1 @ D0 = [3+3, 3+3, 5+5, 5+5] = [6, 6, 10, 10]
    
    bkpt #0