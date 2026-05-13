/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005", "R1": "0x00000005" }
}
*/
.text
.global _start
_start:
    @ Conditional SUB: SUBEQ, SUBNE
    
    mov r0, #10
    mov r1, #5
    
    cmp r0, r0           @ Z=1
    subeq r0, r0, #5     @ R0 = 10 - 5 = 5 (executed)
    subne r1, r1, #3     @ Not executed (Z=1), R1 stays 5
    
    bkpt #0
