/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0707070707070707" }
}
*/
.text
.global _start
_start:
    @ VDUP.8: Vector Duplicate 8-bit
    
    mov r0, #7
    vdup.8 d0, r0           @ d0 = [7, 7, 7, 7, 7, 7, 7, 7]
    
    bkpt #0
