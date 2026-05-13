/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000010001" }
}
*/
.text
.global _start
_start:
    @ VMIN: Minimum
    @ VMIN.S16 Dd, Dn, Dm
    
    ldr r0, =0x00010001
    ldr r1, =0x00000000
    vmov d0, r0, r1         @ D0 = [0, 0x0001_0001]
    
    ldr r0, =0x00020002
    ldr r1, =0x00000000
    vmov d1, r0, r1         @ D1 = [0, 0x0002_0002]
    
    vmin.s16 d0, d0, d1     @ Min: [min(1,2), min(1,2)] = [1, 1]
    
    bkpt #0
.ltorg
