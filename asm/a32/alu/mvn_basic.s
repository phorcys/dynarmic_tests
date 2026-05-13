/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFFE" }
}
*/
.text
.global _start
_start:
    @ MVN: Move NOT
    @ MVN Rd, Operand2
    @ Rd = NOT Operand2
    
    mov r1, #1
    mvn r0, r1           @ R0 = NOT 1 = 0xFFFFFFFE
    
    bkpt #0
