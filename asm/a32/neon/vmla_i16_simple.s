/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x000C000C000C000C" }
}
*/
.text
.global _start
_start:
    @ VMLA.I16: Vector Multiply Accumulate
    
    mov r0, #0
    vdup.16 d0, r0       @ d0 = [0, 0, 0, 0]
    
    mov r0, #3
    vdup.16 d1, r0       @ d1 = [3, 3, 3, 3]
    mov r0, #4
    vdup.16 d2, r0       @ d2 = [4, 4, 4, 4]
    
    vmla.i16 d0, d1, d2  @ d0 = [0+3*4, 0+3*4, 0+3*4, 0+3*4] = [12, 12, 12, 12]
    
    bkpt #0