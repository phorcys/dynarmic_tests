/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000018" }
}
*/
.text
.global _start
_start:
    @ TEQ: Test equivalence (EOR without write)
    @ TEQ Rn, Operand2
    @ Sets flags based on Rn EOR Operand2
    
    ldr r1, =0x18
    teq r1, #0x18           @ 0x18 EOR 0x18 = 0, sets Z=1
    
    mov r0, #0
    moveq r0, #0x18         @ R0 = 0x18 (executed)
    
    bkpt #0
.ltorg
