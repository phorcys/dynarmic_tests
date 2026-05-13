/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000000",
    "R1": "0x000000FF",
    "R2": "0x0000000F"
  }
}
*/
.text
.global _start
_start:
    // AND R0, R1, R2  -> R0 = R1 & R2
    mov r1, #0xF0
    mov r2, #0x0F
    and r0, r1, r2    // R0 = 0xF0 & 0x0F = 0x00
    
    // Test AND with immediate
    mov r1, #0xFF
    and r2, r1, #0x0F  // R2 = 0xFF & 0x0F = 0x0F
    
    bkpt #0