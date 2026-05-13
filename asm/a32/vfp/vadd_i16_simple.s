/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0007000700070007" }
}
*/
.text
.global _start
_start:
    @ VADD.I16: Vector Add 16-bit integers
    
    mov r0, #3
    vdup.16 d0, r0       @ d0 = [3, 3, 3, 3]
    mov r0, #4
    vdup.16 d1, r0       @ d1 = [4, 4, 4, 4]
    
    vadd.i16 d0, d0, d1  @ d0 = [7, 7, 7, 7] = 0x0007000700070007
    
    bkpt #0