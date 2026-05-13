/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000001",
    "R1": "0x00000002",
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
    
    // Conditional ADDLT (signed less than)
    mov r3, #1
    mov r4, #2
    cmp r3, r4        // r3 < r4, so LT condition true
    addlt r0, r0, #1  // Execute: r0 = 1
    
    // Conditional ADDGT (signed greater than)
    cmp r4, r3        // r4 > r3, so GT condition true
    addgt r1, r1, #1  // Execute: r1 = 2
    
    // Conditional ADDGE (signed greater or equal)
    cmp r3, r3        // equal, so GE condition true
    addge r2, r2, #1  // Execute: r2 = 1
    
    bkpt #0
