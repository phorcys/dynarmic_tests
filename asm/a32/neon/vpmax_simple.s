/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000200000001" }
}
*/
.text
.global _start
_start:
    @ VPMAX: Pairwise Maximum
    @ VPMAX.S32 Dd, Dn, Dm
    
    mov r0, #1
    mov r1, #0
    vmov d0, r0, r1         @ D0 = [0, 1] as 32-bit values
    
    mov r0, #2
    mov r1, #0
    vmov d1, r0, r1         @ D1 = [0, 2] as 32-bit values
    
    vpmax.s32 d0, d0, d1    @ Max of pairs from D0 and D1
    
    bkpt #0
.ltorg
