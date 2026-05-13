/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005", "R1": "0x00000002" }
}
*/
.text
.global _start
_start:
    @ Conditional move tests
    mov r0, #1
    mov r1, #2
    mov r2, #5
    mov r3, #3
    
    @ Test EQ
    cmp r0, #1           @ Z=1
    moveq r0, r2         @ Should execute: r0 = 5
    movne r1, r3         @ Should NOT execute: r1 = 2
    
    @ Actually let's test properly
    mov r0, #1
    mov r1, #2
    mov r2, #5
    mov r3, #3
    
    cmp r0, #0           @ Z=0 (not equal)
    movne r0, r2         @ Should execute: r0 = 5
    moveq r1, r3         @ Should NOT execute: r1 = 2
    
    bkpt #0
