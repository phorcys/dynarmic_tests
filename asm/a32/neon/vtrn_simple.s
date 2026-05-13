/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0007000300050001", "D1": "0x0008000400060002" }
}
*/
.text
.global _start
_start:
    @ VTRN: Transpose
    @ VTRN.16 D0, D1
    
    ldr r0, =0x00020001
    ldr r1, =0x00040003
    vmov d0, r0, r1         @ D0 = [0x0004_0003, 0x0002_0001]
    
    ldr r0, =0x00060005
    ldr r1, =0x00080007
    vmov d1, r0, r1         @ D1 = [0x0008_0007, 0x0006_0005]
    
    vtrn.16 d0, d1          @ Transpose
    
    bkpt #0
.ltorg
