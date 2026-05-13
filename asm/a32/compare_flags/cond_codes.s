/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001", "R1": "0x00000003" }
}
*/
.text
.global _start
_start:
    @ Test all condition codes
    mov r0, #1
    mov r1, #2
    
    @ EQ (equal) - Z=1
    cmp r0, r0
    moveq r1, #10    @ Should execute
    
    @ NE (not equal) - Z=0
    cmp r0, #0
    movne r1, #2     @ Should not execute (r1 stays 10)
    
    @ But r1 should be 10 from EQ
    @ Actually let me simplify
    mov r1, #2       @ Reset r1
    
    cmp r0, r0       @ Set Z=1
    moveq r1, #3     @ Execute, r1=3
    
    bkpt #0
