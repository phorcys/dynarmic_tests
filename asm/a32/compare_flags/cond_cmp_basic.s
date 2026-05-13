/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001", "R1": "0x00000002" }
}
*/
.text
.global _start
    @ Conditional CMP: CMPEQ, CMPNE
    @ CMP doesn't write to Rd, only sets flags
    
    mov r0, #5
    mov r1, #5
    
    cmp r0, r1           @ Z=1
    moveq r0, #1         @ R0 = 1 (executed)
    movne r1, #10        @ Not executed
    
    mov r1, #2
    
    bkpt #0
