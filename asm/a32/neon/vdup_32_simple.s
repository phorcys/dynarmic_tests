/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000700000007" }
}
*/
.text
.global _start
_start:
    @ VDUP.32: Vector Duplicate 32-bit
    
    mov r0, #7
    vdup.32 d0, r0          @ d0 = [7, 7]
    
    bkpt #0
