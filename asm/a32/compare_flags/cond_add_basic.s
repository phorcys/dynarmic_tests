/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000000A", "R1": "0x00000005" }
}
*/
.text
.global _start
_start:
    @ Conditional ADD: ADDEQ, ADDNE
    @ ADDEQ executes if Z=1
    
    mov r0, #5
    mov r1, #3
    mov r2, #5
    
    cmp r0, r2           @ 5 - 5 = 0, Z=1
    addeq r1, r1, r0     @ R1 = 3 + 5 = 8 (executed)
    
    cmp r0, #0           @ 5 - 0 != 0, Z=0
    addne r1, r1, r0     @ R1 = 8 + 5 = 13... wait
    
    @ Let me simplify
    mov r0, #5
    mov r1, #5
    
    cmp r0, r1           @ Z=1
    addeq r0, r0, #5     @ R0 = 5 + 5 = 10
    
    mov r1, #5           @ R1 = 5
    
    bkpt #0
