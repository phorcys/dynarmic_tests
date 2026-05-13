/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x000000FF",
    "R1": "0x000000FF",
    "R2": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    // EOR R0, R1, R2  -> R0 = R1 ^ R2
    mov r1, #0xF0
    mov r2, #0x0F
    eor r0, r1, r2    // R0 = 0xF0 ^ 0x0F = 0xFF
    
    // Test EOR with immediate
    mov r1, #0xFF
    eor r2, r1, #0xFF  // R2 = 0xFF ^ 0xFF = 0x00
    
    bkpt #0