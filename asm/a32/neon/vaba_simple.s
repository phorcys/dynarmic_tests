/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000020002" }
}
*/
.text
.global _start
_start:
    @ VABA: Absolute Difference and Accumulate
    @ VABA.S16 Dd, Dn, Dm
    
    mov r0, #0
    mov r1, #0
    vmov d0, r0, r1         @ D0 = [0, 0]
    
    ldr r0, =0x00020002
    ldr r1, =0x00000000
    vmov d1, r0, r1         @ D1 = [0, 0x0002_0002]
    
    vaba.s16 d0, d0, d1     @ D0 += |D0 - D1|: |0-2|, |0-2| = [2, 2]
    
    bkpt #0
.ltorg
