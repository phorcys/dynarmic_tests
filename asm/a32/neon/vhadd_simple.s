/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000500000005" }
}
*/
.text
.global _start
_start:
    @ VHADD.U32: Vector Halving Add
    
    mov r0, #3
    vdup.32 d0, r0          @ d0 = [3, 3]
    mov r0, #7
    vdup.32 d1, r0          @ d1 = [7, 7]
    
    vhadd.u32 d0, d0, d1    @ d0 = [(3+7)>>1, (3+7)>>1] = [5, 5]
    
    bkpt #0
