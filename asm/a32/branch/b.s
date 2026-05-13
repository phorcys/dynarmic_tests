/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000002",
    "R1": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    mov r0, #0
    mov r1, #0
    
    // Branch forward
    b skip1
    mov r0, #1        // Should be skipped
skip1:
    add r0, r0, #1    // r0 = 1
    
    // Branch back
    b skip2
    mov r1, #1        // Should be skipped
skip2:
    add r0, r0, #1    // r0 = 2
    
    bkpt #0
