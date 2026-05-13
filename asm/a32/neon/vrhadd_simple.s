/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000050003" }
}
*/
.text
.global _start
_start:
    @ VRHADD: Rounding Halving Add
    @ VRHADD.S16 Dd, Dn, Dm
    
    ldr r0, =0x00040002
    ldr r1, =0x00000000
    vmov d0, r0, r1         @ D0 = [0, 0x0004_0002]
    
    ldr r0, =0x00050003
    ldr r1, =0x00000000
    vmov d1, r0, r1         @ D1 = [0, 0x0005_0003]
    
    vrhadd.s16 d0, d0, d1   @ Rounding halving add
    
    bkpt #0
.ltorg
