/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x000000FF",
    "R1": "0x000000F0",
    "R2": "0x000000FF"
  }
}
*/
.text
.global _start
_start:
    // ORR R0, R1, R2  -> R0 = R1 | R2
    mov r1, #0xF0
    mov r2, #0x0F
    orr r0, r1, r2    // R0 = 0xF0 | 0x0F = 0xFF
    
    // Test ORR with immediate
    mov r1, #0xF0
    orr r2, r1, #0x0F  // R2 = 0xF0 | 0x0F = 0xFF
    
    bkpt #0