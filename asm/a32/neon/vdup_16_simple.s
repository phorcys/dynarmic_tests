/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0007000700070007" }
}
*/
.text
.global _start
_start:
    @ VDUP.16: Vector Duplicate 16-bit
    
    mov r0, #7
    vdup.16 d0, r0          @ d0 = [7, 7, 7, 7]
    
    bkpt #0
