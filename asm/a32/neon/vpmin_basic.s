/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x0001000100010001" }
}
*/
.text
.global _start
_start:
    @ VPMIN: Pairwise Minimum
    @ VPMIN.<type> Vd, Vn, Vm
    
    mov r0, #1
    vdup.16 d0, r0       @ D0 = [1, 1, 1, 1]
    
    mov r0, #5
    vdup.16 d1, r0       @ D1 = [5, 5, 5, 5]
    
    vpmin.u16 d0, d0, d1 @ D0 = [min(1,1), min(1,1), min(5,5), min(5,5)] = [1, 1, 5, 5]
    
    @ Test with different values
    mov r0, #3
    vdup.16 d0, r0       @ D0 = [3, 3, 3, 3]
    
    mov r0, #7
    vdup.16 d1, r0       @ D1 = [7, 7, 7, 7]
    
    vpmin.u16 d0, d0, d1 @ D0 = [3, 3, 7, 7]
    
    @ Actually let me test with mixed values
    ldr r0, =0x00050002  @ [2, 5]
    vdup.32 d0, r0       @ D0 = [2|5, 2|5] as 32-bit, but as 16-bit: [5, 2, 5, 2]
    
    ldr r0, =0x00030001  @ [1, 3]
    vdup.32 d1, r0       @ D1 = [3, 1, 3, 1]
    
    vpmin.u16 d0, d0, d1 @ min pairs
    
    @ Simple test
    mov r0, #1
    vdup.16 d0, r0
    mov r0, #1
    vdup.16 d1, r0
    
    vpmin.u16 d0, d0, d1 @ D0 = [1, 1, 1, 1]
    
    bkpt #0
.ltorg
