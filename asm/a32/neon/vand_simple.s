/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000300000003" }
}
*/
.text
.global _start
_start:
    @ VAND: Vector AND
    
    mov r0, #7
    vdup.32 d0, r0       @ d0 = [7, 7] = 0x0000000700000007
    mov r0, #3
    vdup.32 d1, r0       @ d1 = [3, 3]
    
    vand d0, d0, d1      @ d0 = [7&3, 7&3] = [3, 3] = 0x0000000300000003
    
    bkpt #0