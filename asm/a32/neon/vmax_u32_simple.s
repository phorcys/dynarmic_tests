/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000500000005" }
}
*/
.text
.global _start
_start:
    @ VMAX.U32: Vector Maximum
    
    mov r0, #3
    vdup.32 d0, r0          @ d0 = [3, 3]
    mov r0, #5
    vdup.32 d1, r0          @ d1 = [5, 5]
    
    vmax.u32 d0, d0, d1     @ d0 = [max(3,5), max(3,5)] = [5, 5]
    
    bkpt #0
