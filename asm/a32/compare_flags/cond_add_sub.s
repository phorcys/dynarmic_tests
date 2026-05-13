/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001", "R1": "0x00000002" }
}
*/
.text
.global _start
_start:
    @ Conditional add/sub tests
    mov r0, #1
    mov r1, #2
    
    @ Test EQ (equal)
    cmp r0, #1           @ Z=1
    addeq r0, r0, #10    @ Should execute: r0 = 11
    addne r1, r1, #10    @ Should NOT execute: r1 = 2
    
    @ Reset
    mov r0, #1
    mov r1, #2
    
    @ Test NE (not equal)
    cmp r0, #2           @ Z=0
    addne r0, r0, #10    @ Should execute: r0 = 11
    addeq r1, r1, #10    @ Should NOT execute: r1 = 2
    
    @ Reset  
    mov r0, #1
    mov r1, #2
    
    @ Test GT (greater than)
    cmp r0, #0           @ N=0, Z=0, C=1, V=0
    addgt r0, r0, #10    @ Should execute: r0 = 11
    
    @ Reset
    mov r0, #1
    mov r1, #2
    
    @ Test LT (less than)
    cmp r0, #2           @ N=1, Z=0, C=0, V=0
    addlt r0, r0, #10    @ Should execute: r0 = 11
    
    @ Simple test
    mov r0, #1
    mov r1, #2
    
    cmp r0, r0           @ EQ
    addeq r0, r0, #0     @ r0 stays 1
    
    bkpt #0
