/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x000E000E000E000E" }
}
*/
.text
.global _start
_start:
    @ VMUL: Vector Multiply
    mov r0, #7
    vdup.16 d0, r0     @ D0 = [7, 7, 7, 7]
    mov r0, #2
    vdup.16 d1, r0     @ D1 = [2, 2, 2, 2]
    
    vmul.i16 d0, d0, d1  @ D0 = [14, 14, 14, 14]
    
    bkpt #0
