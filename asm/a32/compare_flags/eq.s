/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000001",
    "R1": "0x00000001",
    "R2": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    mov r0, #0
    mov r1, #1
    mov r2, #0
    
    // Conditional ADDEQ (execute if Z=1)
    cmp r1, #1        // Z=1 (equal)
    addeq r0, r0, #1  // Should execute: r0 = 1
    
    // Conditional ADDNE (execute if Z=0)  
    cmp r1, #2        // Z=0 (not equal)
    addne r2, r2, #1  // Should execute: r2 = 1
    
    bkpt #0