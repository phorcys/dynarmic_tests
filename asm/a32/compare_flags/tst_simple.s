/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000018" }
}
*/
.text
.global _start
_start:
    @ TST: Test bits (AND without write)
    @ TST Rn, Operand2
    @ Sets flags based on Rn AND Operand2
    
    ldr r1, =0x1F
    tst r1, #0x18           @ Test bits 3 and 4, sets Z=0, N=1
    
    @ Get flags - use move to save
    mov r0, #0
    moveq r0, #1            @ Not executed (Z=0)
    movne r0, #24           @ R0 = 24 = 0x18 (executed)
    
    bkpt #0
.ltorg
