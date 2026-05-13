/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x000000F0",
    "R1": "0x000000FF",
    "R2": "0x000000F0"
  }
}
*/
.text
.global _start
_start:
    // BIC R0, R1, R2  -> R0 = R1 & ~R2
    mov r1, #0xFF
    mov r2, #0x0F
    bic r0, r1, r2    // R0 = 0xFF & ~0x0F = 0xF0
    
    // Test BIC with immediate
    mov r1, #0xFF
    bic r2, r1, #0x0F  // R2 = 0xFF & ~0x0F = 0xF0
    
    bkpt #0