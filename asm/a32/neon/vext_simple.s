/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000200000000" }
}
*/
.text
.global _start
_start:
    @ VEXT: Extract vector from pair
    @ VEXT.8 Dd, Dn, Dm, #imm
    
    mov r0, #1
    mov r1, #0
    vmov d0, r0, r1         @ D0 = [0, 1] as 32-bit values
    
    mov r0, #2
    mov r1, #3
    vmov d1, r0, r1         @ D1 = [3, 2] as 32-bit values
    
    vext.8 d0, d0, d1, #4   @ Extract starting from byte 4
    
    bkpt #0
.ltorg
