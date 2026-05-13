/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000000003" }
}
*/
.text
.global _start
_start:
    @ VPADDL: Pairwise Add Long
    @ VPADDL.S32 Dd, Dm - Add adjacent pairs of 32-bit signed values
    
    mov r0, #1
    mov r1, #2
    vmov d0, r0, r1         @ D0 = [2, 1] as 32-bit values (high, low)
    
    vpaddl.s32 d0, d0       @ Add pairs of 32-bit: low + high = 1 + 2 = 3
    
    bkpt #0
.ltorg
