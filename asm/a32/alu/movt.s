/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x12340001"
  }
}
*/
.text
.global _start
_start:
    // MOVT - Move 16-bit immediate to top of register
    movw r0, #0x0001  // r0 = 0x00000001
    movt r0, #0x1234  // r0 = 0x12340001
    
    bkpt #0
