/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000020002" }
}
*/
.text
.global _start
_start:
    @ VABD: Absolute Difference
    @ VABD.S16 Dd, Dn, Dm
    
    ldr r0, =0x00020001
    ldr r1, =0x00000000
    vmov d0, r0, r1         @ D0 = [0, 0x0002_0001]
    
    ldr r0, =0x00040003
    ldr r1, =0x00000000
    vmov d1, r0, r1         @ D1 = [0, 0x0004_0003]
    
    vabd.s16 d0, d0, d1     @ |D0 - D1|: [|1-3|, |2-4|] = [2, 2]
    
    bkpt #0
.ltorg
