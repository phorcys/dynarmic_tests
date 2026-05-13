/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000300000003" }
}
*/
.text
.global _start
_start:
    @ VMIN.U32: Vector Minimum
    
    mov r0, #3
    vdup.32 d0, r0          @ d0 = [3, 3]
    mov r0, #5
    vdup.32 d1, r0          @ d1 = [5, 5]
    
    vmin.u32 d0, d0, d1     @ d0 = [min(3,5), min(3,5)] = [3, 3]
    
    bkpt #0
