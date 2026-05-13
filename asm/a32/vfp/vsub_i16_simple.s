/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0004000400040004" }
}
*/
.text
.global _start
_start:
    @ VSUB.I16: Vector Subtract 16-bit integers
    
    mov r0, #7
    vdup.16 d0, r0       @ d0 = [7, 7, 7, 7]
    mov r0, #3
    vdup.16 d1, r0       @ d1 = [3, 3, 3, 3]
    
    vsub.i16 d0, d0, d1  @ d0 = [7-3, 7-3, 7-3, 7-3] = [4, 4, 4, 4]
    
    bkpt #0