/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x000000000000000a" }
}
*/
.text
.global _start
_start:
    @ VPADAL: Pairwise Add and Accumulate Long
    @ VPADAL.S32 Dd, Dm - Add adjacent pairs and accumulate
    
    mov r0, #1
    mov r1, #2
    vmov d0, r0, r1         @ D0 = [2, 1] as 32-bit values
    
    vpaddl.s32 d0, d0       @ D0 = 1 + 2 = 3
    
    mov r0, #3
    mov r1, #4
    vmov d1, r0, r1         @ D1 = [4, 3] as 32-bit values
    
    vpadal.s32 d0, d1       @ D0 = 3 + (3 + 4) = 10
    
    bkpt #0
.ltorg
