/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0006000600060006" }
}
*/
.text
.global _start
_start:
    @ VMUL.I16: Vector Multiply 16-bit integers
    
    mov r0, #3
    vdup.16 d0, r0       @ d0 = [3, 3, 3, 3]
    mov r0, #2
    vdup.16 d1, r0       @ d1 = [2, 2, 2, 2]
    
    vmul.i16 d0, d0, d1  @ d0 = [3*2, 3*2, 3*2, 3*2] = [6, 6, 6, 6]
    
    bkpt #0