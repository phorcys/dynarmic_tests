/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x0000000D"
  }
}
*/
.text
.global _start
_start:
    // Conditional ADD: ADDEQ, ADDNE
    mov r0, #0
    
    cmp r0, #0         // Z=1 (equal)
    addeq r0, r0, #1   // Execute: r0 = 1
    
    cmp r0, #2         // Z=0 (not equal)
    addne r0, r0, #2   // Execute: r0 = 3
    
    cmp r0, #3         // Z=1 (equal)
    addeq r0, r0, #4   // Execute: r0 = 7
    
    cmp r0, #5         // Z=0 (not equal)
    addne r0, r0, #6   // Execute: r0 = 13
    
    bkpt #0