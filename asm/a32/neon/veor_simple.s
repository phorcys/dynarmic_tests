/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000400000004" }
}
*/
.text
.global _start
_start:
    @ VEOR: Vector EOR (XOR)
    
    mov r0, #7
    vdup.32 d0, r0       @ d0 = [7, 7]
    mov r0, #3
    vdup.32 d1, r0       @ d1 = [3, 3]
    
    veor d0, d0, d1      @ d0 = [7^3, 7^3] = [4, 4] = 0x0000000400000004
    
    bkpt #0