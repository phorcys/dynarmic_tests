/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000012" }
}
*/
.text
.global _start
_start:
    @ RSB: Reverse Subtract
    @ RSB Rd, Rn, Operand2
    @ Rd = Operand2 - Rn
    
    mov r1, #10
    
    rsb r0, r1, #24    @ R0 = 24 - 10 = 14
    
    @ Another test
    rsb r0, r1, #4     @ R0 = 4 - 10 = -6... wait that's signed
    
    mov r1, #6
    rsb r0, r1, #24    @ R0 = 24 - 6 = 18
    
    bkpt #0
