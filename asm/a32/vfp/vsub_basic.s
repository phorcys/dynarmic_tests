/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x0001000100010001" }
}
*/
.text
.global _start
_start:
    @ VSUB: Vector Subtract
    mov r0, #10
    vdup.16 d0, r0     @ D0 = [10, 10, 10, 10] (4 x 16-bit)
    mov r0, #9
    vdup.16 d1, r0     @ D1 = [9, 9, 9, 9]
    
    vsub.i16 d0, d0, d1  @ D0 = [1, 1, 1, 1]
    
    bkpt #0
