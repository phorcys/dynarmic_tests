/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x0002000200020002" }
}
*/
.text
.global _start
_start:
    @ VSWP: Vector Swap
    @ VSWP Vd, Vm
    
    mov r0, #1
    vdup.16 d0, r0       @ D0 = [1, 1, 1, 1]
    
    mov r0, #2
    vdup.16 d1, r0       @ D1 = [2, 2, 2, 2]
    
    vswp d0, d1          @ Swap D0 and D1
    
    @ D0 = [2, 2, 2, 2], D1 = [1, 1, 1, 1]
    
    bkpt #0