/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000000A", "R1": "0x00000014" }
}
*/
.text
.global _start
_start:
    @ Conditional compare tests
    mov r0, #10
    mov r1, #20
    
    @ Test conditional compare
    cmp r0, #5           @ 10 > 5, sets flags: N=0, Z=0, C=1, V=0
    
    @ Conditional compare - executes because GT is true
    cmpgt r1, #10        @ 20 > 10, sets flags
    
    mov r0, #10
    mov r1, #20
    
    cmp r0, #10          @ 10 == 10, Z=1
    
    @ Conditional compare - executes because EQ is true
    cmpeq r1, #20        @ 20 == 20, Z=1
    
    bkpt #0
