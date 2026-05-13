/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000001",
    "R1": "0x00000002",
    "R2": "0x00000003"
  }
}
*/
.text
.global _start
_start:
    // PUSH/POP - Stack operations
    mov r0, #1
    mov r1, #2
    mov r2, #3
    
    push {r0, r1, r2}  // Push r0, r1, r2 onto stack
    
    mov r0, #0
    mov r1, #0
    mov r2, #0
    
    pop {r0, r1, r2}   // Pop from stack
    
    bkpt #0