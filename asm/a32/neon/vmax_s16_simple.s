/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000030003" }
}
*/
.text
.global _start
_start:
    @ VMAX: Maximum
    @ VMAX.S16 Dd, Dn, Dm
    
    ldr r0, =0x00030003
    ldr r1, =0x00000000
    vmov d0, r0, r1         @ D0 = [0, 0x0003_0003]
    
    ldr r0, =0x00020001
    ldr r1, =0x00000000
    vmov d1, r0, r1         @ D1 = [0, 0x0002_0001]
    
    vmax.s16 d0, d0, d1     @ Max: [max(3,1), max(3,2)] = [3, 3]
    
    bkpt #0
.ltorg
