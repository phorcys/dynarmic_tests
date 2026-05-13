/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005", "R1": "0x00000003" }
}
*/
.text
.global _start
_start:
    @ Conditional AND, ORR, EOR
    
    mov r0, #7
    mov r1, #5
    
    cmp r0, #7           @ Z=0 (not equal to zero)
    andne r0, r0, #5     @ R0 = 7 & 5 = 5 (executed)
    
    cmp r0, #5           @ Z=1
    orreq r1, r1, #1     @ R1 = 5 | 1 = 6... wait
    
    @ Let me simplify
    mov r0, #7
    mov r1, #3
    
    cmp r0, #0           @ Z=0
    andne r0, r0, #5     @ R0 = 7 & 5 = 5
    
    bkpt #0
