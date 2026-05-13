/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x0004000400040004" }
}
*/
.text
.global _start
_start:
    @ VABA: Vector Absolute Difference and Accumulate
    @ VABA.<size> Vd, Vn, Vm
    @ Vd = Vd + |Vn - Vm|
    
    mov r0, #1
    vdup.16 d0, r0       @ D0 = [1, 1, 1, 1]
    
    mov r0, #5
    vdup.16 d1, r0       @ D1 = [5, 5, 5, 5]
    
    mov r0, #2
    vdup.16 d2, r0       @ D2 = [2, 2, 2, 2]
    
    vaba.u16 d0, d1, d2  @ D0 = [1, 1, 1, 1] + |[5,5,5,5] - [2,2,2,2]| 
                         @    = [1, 1, 1, 1] + [3, 3, 3, 3] = [4, 4, 4, 4]
    
    bkpt #0