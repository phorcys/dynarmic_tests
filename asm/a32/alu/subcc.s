/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xFFFFFFFF",
    "R1": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    // Conditional SUB: SUBNE, SUBEQ
    mov r0, #0
    mov r1, #5
    
    cmp r0, #0         // Z=1 (equal)
    subne r1, r1, #1   // NOT execute: r1 stays 5
    
    cmp r0, #1         // Z=0 (not equal)
    subne r1, r1, #4   // Execute: r1 = 5 - 4 = 1
    
    // Test with overflow
    mvn r0, #0         // r0 = 0xFFFFFFFF (-1)
    
    bkpt #0